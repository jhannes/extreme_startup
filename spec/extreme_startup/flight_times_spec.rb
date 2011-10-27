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
      end

    end
  end
end

