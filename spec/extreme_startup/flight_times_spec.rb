require 'spec_helper'
require 'extreme_startup/question_factory'
require 'extreme_startup/questions/flight_time'
require 'extreme_startup/player'

module ExtremeStartup::Questions
  describe  FlightTime do

    context "First question" do
	
      let(:conversation) { FlightTime.new(Player.new) }

      it "should start by for places in same timezone" do
	      question = conversation.question
        question.should =~ /A flight from Paris to Oslo leaves from Paris 29\.10\.2011 at 08\:00. It takes \d+ minutes. When \(local time\) does it land in Oslo \?/		
		    number = question.scan(/It takes (\d+) minutes/).first.first.to_i
		    conversation.correct_answer.should == conversation.compute_answer(2011,10,29,8,0,number)
      end
	  
	    it "should compute correct answer when in same timezone" do
		    conversation.compute_answer(2011,10,23,8,0,30).should == "23.10.2011 at 08:30"
		    conversation.compute_answer(2011,10,23,8,0,150).should == "23.10.2011 at 10:30"
		    conversation.compute_answer(2011,10,23,23,0,150).should == "24.10.2011 at 01:30"
		
	    end

	    it "should compute correct answer when in different" do
		    conversation.compute_answer(2011,10,23,8,0,30,"+01:00").should == "23.10.2011 at 09:30"
	    end
	    
	    it "should give correct score" do
	      conversation.points.should == 30
	      conversation.penalty.should == -10
	    end
    end
	
	
    context "when player has answered twenty questions time zone is introduced" do
      let(:player) { Player.new }
      let(:conversation) { FlightTime.new(player) }
      
      it "ask for different time zone" do
        10.times { player.answers_for_question(FlightTime,  "correct") }
		    question = conversation.question
        question.include?("London").should == true		
		    number = question.scan(/It takes (\d+) minutes/).first.first.to_i
		    conversation.correct_answer.should == conversation.compute_answer(2011,10,29,8,0,number,"+01:00")
      end
	  
	    it "should unleash hell when 30 questions are answered correctly" do
		    20.times { player.answers_for_question(FlightTime,  "correct") }
		    question = conversation.question
		    question.include?("A jetplane").should == true		      
	    end
	    
	    it "should give large penalty when questions has been answered correctly" do
	      player.answers_for_question(FlightTime,  "correct")
	      conversation.penalty.should == -300
	    end
	    
    end	
	
  end
end

