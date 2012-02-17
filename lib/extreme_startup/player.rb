require 'uuid'

module ExtremeStartup
  
  class LogLine
    attr_reader :id, :result, :points
    def initialize(id, result, points)
      @id = id
      @result = result
      @points = points
    end
    
    def to_s
      "#{@id}: #{@result} - points awarded: #{@points}"
    end
  end
  
  class Player
    attr_reader :name, :url, :uuid, :log

    class << self
      def generate_uuid
        @uuid_generator ||= UUID.new
        @uuid_generator.generate.to_s[0..7]
      end
    end

    def initialize(params = {})  
      @name = params['name']
      @url = params['url']
      @uuid = Player.generate_uuid
      @log = []
      @correct_answers = Hash.new(0)
      @wrong_answers = Hash.new(0)
    end

    def log_result(id, msg, points)
      @log.unshift(LogLine.new(id, msg, points))
    end

    def to_s
      "#{name} (#{@uuid}: #{url})"
    end
  
   def answers_for_question(question_class, result)
    if result == "correct"
      @correct_answers[question_class] += 1
    elsif result == "wrong"
      @wrong_answers[question_class] += 1
     end
   end
   def correct_answers(question_class)
     @correct_answers[question_class]
   end
   def correct_answer_count
     @correct_answers.values.count { |v| v > 0 }
   end
   def wrong_answers(question_class)
    @wrong_answers[question_class] += 1
   end
  end
end