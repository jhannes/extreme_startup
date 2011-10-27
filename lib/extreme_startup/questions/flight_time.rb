module ExtremeStartup::Questions
  include ExtremeStartup

  class FlightTime < Question
    
    def initialize()
      
    end

    def question
      
      return "A flight from Paris to Oslo leaves from Paris 23.10.2011 at 08:00. It takes 150 minutes. When does it land in Oslo ?"
    end

  
    def add_answer(answer)
    end

    def answered_correctly?
      
      true
    end

    def points
      return 0
    end
    
  
    def penalty
      return 0
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
