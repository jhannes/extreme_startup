module ExtremeStartup::Questions
  include ExtremeStartup

  class FlightTime < Question
    
    def initialize(player)
      super(player)
    end

    def question
      minutes = Random.rand(60)+110;
      return "A flight from Paris to Oslo leaves from Paris 29.10.2011 at 08:00. It takes #{minutes} minutes. When (local time) does it land in Oslo ?"
    end

  
    def add_answer(answer)
    end

    def answered_correctly?
      
      true
    end
	
	def correct_answer(year,month,day,hour,minutes,duration,timezone_offset="+00:00")
	    ctime = Time.utc(year,month,day,hour,minutes).localtime(timezone_offset) + (duration*60)
		ctime = ctime + (adjust_by_hours*60)
		return "#{"%02d" % ctime.day}.#{"%02d" % ctime.month}.#{ctime.year} at #{"%02d" % ctime.hour}:#{"%02d" % ctime.min}"
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
