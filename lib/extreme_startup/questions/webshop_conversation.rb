module ExtremeStartup::Questions
  include ExtremeStartup

  class WebshopConversation < Conversation
    class WebshopState
    end
    class RequestingProductList < WebshopState
    end
    class RequestingPrice < WebshopState
    end
    class Shopping < WebshopState
    end
    class DoneShopping < WebshopState
    end
    class Done < WebshopState
    end

    def initialize(product_list = nil, shopping_cart = {})
      @shoppedProducts = 0
      @product_list = product_list
      @shopping_cart = shopping_cart
      if (@product_list == nil || @product_list.empty?)
        @state = RequestingProductList
      elsif (@product_list.has_value?(nil))
        @state = RequestingPrice
      else
        @state = Shopping
      end
    end

    def dead?
      not answered_correctly? or @state == Done
    end

    def question
      @queried_product = @purchased_product = nil
      if @state == RequestingProductList
        if (@product_list == nil)
          return "what products do you have for sale (comma separated)"
        else
          @state = RequestingPrice
        end
      end

      if @state == RequestingPrice
        if ready_to_shop?
          @queried_product = @product_list.keys.sample
          return "how many dollars does one #{@queried_product} cost"
        end
        @state = Shopping
      end

      if @state == Shopping
        if (@shopping_cart.size == 4 || @shopping_cart.size == @product_list.size)
          @state = DoneShopping
        else
          @purchased_product = @product_list.keys.sample
          @purchased_amount = rand(20)
          return "please put #{@purchased_amount} #{@purchased_product} in my shopping cart"
        end
      end

      if @state == DoneShopping
        @state = Done
        return "what is my order total"
      end

      return "Why am I here ?"
    end

    def ready_to_shop?
      @product_list.has_value?(nil)
    end

    def add_answer(answer)
      if @state == RequestingProductList
        @product_list = {}
        answer.split(",").each { |p| @product_list[p.strip] = nil }
      elsif @state == RequestingPrice
        @price = Float(answer) rescue nil
        @product_list[@queried_product] = @price
      elsif @state == Shopping
        @shopping_cart[@purchased_product] = @purchased_amount
      end
      @answer = answer
    end

    def price_for(product)
      @product_list[product]
    end

    def correct_answer
      if @state == Done
        return order_total
      end
      nil
    end

    def order_total
      total = 0
      for product in @product_list.keys
        total += @shopping_cart[product] * price_for(product)
      end
      total
    end

    def answered_correctly?
      if @state == RequestingProductList
        return @product_list && @product_list.size > 1
      elsif @state == RequestingPrice
        return @price
      elsif @state == Done
        return (Float(@answer.strip) rescue nil) == order_total
      end
      true
    end

    def shopping_cart_count_for(product)
      @shopping_cart[product]
    end

    def points
      return points_for_products if @state == RequestingProductList
      return duplicate_prices? ? 1 : 40 if @state == RequestingPrice
      return 500 if @state == Done
      return 0
    end
    
    def points_for_products
      first_products = @answer.split(",")[0..10]
      first_products.collect { |product| product =~ /\d/ ? 1 : 10 }.inject(0) { |sum,i| sum+i }
    end

    def duplicate_prices?
       if @product_list == nil || @product_list.empty?
         return false
       end
       given_values = @product_list.values.compact.reject { nil }
       unique_values = given_values & given_values
       return unique_values.size != given_values.size
    end

    def penalty
      return -1 if @state == RequestingProductList
      return -5 if @state == RequestingPrice
      return -200 if @state == Done
      return 0
    end
  end

  class WebshopQuestion < ConversationalQuestion
    def create_session
      WebshopConversation.new
    end

    def spawn?(sessions, spawn_rate)
      return true if sessions.empty?
      return false if sessions.length > 3
      (rand(100) < spawn_rate)
    end

    def score
      case result
        when "correct"      then points
        when "wrong"        then penalty
        when "error_response" then -5
        when "no_answer"     then -20
        else puts "!!!!! result #{result} in score"
      end
    end
  end
end
