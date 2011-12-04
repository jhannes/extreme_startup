require 'spec_helper'
require 'extreme_startup/question_factory'
require 'extreme_startup/player'

module ExtremeStartup
  describe FibonacciQuestion do
    let(:question) { FibonacciQuestion.new(Player.new, 2, nil) }
    
    it "converts to a string" do
      question.as_text.should =~ /what is the \d+th number in the Fibonacci sequence/i
    end
    
    context "when the numbers are known" do
      let(:question) { FibonacciQuestion.new(Player.new, 2, nil) }
        
      it "converts to the right string" do
        question.as_text.should =~ /what is the 6th number in the Fibonacci sequence/i
      end
      
      it "identifies a correct answer" do
        question.answered_correctly?("8").should be_true
      end

      it "identifies an incorrect answer" do
        question.answered_correctly?("5").should be_false
      end
    end
    
    context "when the user has answered a lot of fibbs" do
      let(:player) { Player.new }
      let(:question) { FibonacciQuestion.new(player) }
      
      it "asks for a really big number" do
        20.times { player.answers_for_question(FibonacciQuestion,  "correct") }
        question.which_number.should >= 200
      end
      
      it "asks for extremely big numbers" do
        30.times { player.answers_for_question(FibonacciQuestion,  "correct") }
        question.which_number.should >= 1000    
      end
    end
    
    context "when checking large fibs" do
      it "should answer correctly quickly" do
        question = FibonacciQuestion.new(Player.new, 200)
        question.which_number.should == 204
        question.correct_answer.should == 1923063428480944139667114773918309212080528
      end
      it "should answer quickly for extreme numbers" do
        question = FibonacciQuestion.new(Player.new, 1100)
        startTime = Time.now
        question.correct_answer
        execTime = Time.now - startTime
        execTime.should < 0.2
      end
    end
    
  end
end
