require 'spec_helper'
require 'extreme_startup/question_factory'
require 'extreme_startup/player'

class DummyQuestion < ExtremeStartup::Question
  def points; 1000; end
  def as_text; "some question"; end
  def correct_answer; "correct"; end
end

class DummyQuestion2 < DummyQuestion
end

module ExtremeStartup
  describe Question do
    let(:player)   { Player.new }
    let(:question) { DummyQuestion.new(player) }
	
	it "should have normal delay on correct answer" do
	  question.answer = "correct"
	  question.delay_before_next(50).should == 50
	end
	
	it "should have double delay on incorrect answer" do
	  question.answer = "incorrect"
	  question.delay_before_next(50).should == 100
	end
  
    it "should pay out points for correct answer" do
	  question.answer = "correct"
     question.score.should == 1000
    end
	
	it "should penalize points/10 for incorrect answer" do
	  question.answer = "incorrect"
	  question.score.should == -100
	end
	
	it "should not reduce score when other player scores a lot" do
	  player2 = Player.new
	  10.times { DummyQuestion.new(player2).answer = "correct" }
	  question.answer = "correct"
	  question.score.should == 1000
	end
	
	it "should not reduce score when player scores on other question" do
	  10.times { DummyQuestion2.new(player).answer = "correct" }
	  question.answer = "correct"
	  question.score.should == 1000
	end
	
	it "should reduce score when player scores a lot" do
	  10.times { DummyQuestion.new(player).answer = "correct"}
	  question.answer = "correct"
	  question.score.should == 100
	end
	
	it "should reduce penalty when player initially fails a lot" do
	  10.times { DummyQuestion.new(player).answer = "incorrect"}
	  question.answer = "incorrect"
	  question.score.should == -10
	end
	
	it "should increase penalty when player fails after correct answer" do
	  10.times { DummyQuestion.new(player).answer = "incorrect" }
	  1.times { DummyQuestion.new(player).answer = "correct"}
	  question.answer = "incorrect"
	  question.score.should == -500
	end
  end
end