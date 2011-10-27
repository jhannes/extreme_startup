require 'spec_helper'
require 'extreme_startup/question_factory'
require 'extreme_startup/questions/flight_time'

module ExtremeStartup::Questions
  describe  FlightTime do

    context "client doesn't know what the player can offer" do
      let(:conversation) { FlightTime.new }

      it "should start by asking for products" do
        conversation.question.should == "A flight from Paris to Oslo leaves from Paris 23.10.2011 at 08:00. It takes 150 minutes. When does it land in Oslo ?"
      end

    end
  end
end

