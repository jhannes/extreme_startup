module ExtremeStartup::Questions
  include ExtremeStartup
  
  class FlightTime < Question
    
    def initialize(player)
      super(player)
      if (@player.correct_answers(self.class) >= 20)
        seed = Random.rand(5)
        case seed
        when 0
          minutes = Random.rand(60)+110;
          @fact = compute_answer(2011,10,29,8,0,minutes,"+01:00")
          @question_text = "A jetplane from London to Oslo leaves 29.10.2011 at 08:00. It takes #{minutes} minutes. When (local time) does it land in Oslo ?"
        when 1            
          minutes = Random.rand(60)+110;
          @fact = compute_answer(2011,10,29,8,0,minutes)            
          @question_text = "A jetplane from Paris to Oslo leaves from Paris 29.10.2011 at 08:00. It takes #{minutes} minutes. When (local time) does it land in Oslo ?"
        when 2
          minOfHour = Random.rand(60)
          minutes = Random.rand(60)+300;
          @fact = compute_answer(2011,10,29,8,0,minutes)
          @question_text = "A jetplane from New Your takes off 29.10.2011 at 03:#{"%02d" % minOfHour}. It takes #{minutes} minutes. When (local time) does it land in Oslo ?"
          @fact = compute_answer(2011,10,29,8,minOfHour,minutes)
        when 3
          minOfHour = Random.rand(60)
          minutes = Random.rand(60)+180;
          @question_text = "A jetplane from Rome takes off 30.10.2011 at 01:#{"%02d" % minOfHour}. It takes #{minutes} minutes. When (local time) does it land in Oslo ?"
          @fact = compute_answer(2011,10,30,0,minOfHour,minutes)
        when 4
          minOfHour = Random.rand(30)
          minutes = Random.rand(20)+60;
          @question_text = "A jetplane leaves Cophenhagen March 27th 2011 at 01:#{"%02d" % minOfHour}. It takes #{minutes} minutes. When (local time) does it land in Oslo ?"
          @fact = compute_answer(2011,3,27,2,minOfHour,minutes)    
        end
      else
        minutes = Random.rand(60)+110;
        if (player.correct_answers(self.class) >= 10)
          @fact = compute_answer(2011,10,29,8,0,minutes,"+01:00")
          @question_text = "A flight from London to Oslo leaves 29.10.2011 at 08:00. It takes #{minutes} minutes. When (local time) does it land in Oslo ?"
        else
          @fact = compute_answer(2011,10,29,8,0,minutes)
          @question_text = "A flight from Paris to Oslo leaves from Paris 29.10.2011 at 08:00. It takes #{minutes} minutes. When (local time) does it land in Oslo ?"
        end 
      end
    end

    def question
      return @question_text
    end
    
    def as_text
      return question
    end
        
    def correct_answer
      return @fact
    end

    def compute_answer(year,month,day,hour,minutes,duration,timezone_offset="+00:00")
      ctime = Time.utc(year,month,day,hour,minutes).localtime(timezone_offset) + (duration*60)
      return "#{"%02d" % ctime.day}.#{"%02d" % ctime.month}.#{ctime.year} at #{"%02d" % ctime.hour}:#{"%02d" % ctime.min}"
    end

    def points
      return 30
    end

    def penalty
      return -300 if @player.correct_answers(self.class) > 0
      return -10
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
