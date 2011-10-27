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
    end
	
  end
end

