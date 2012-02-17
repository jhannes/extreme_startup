require 'rubygems'
require_relative 'lib/extreme_startup/web_server'
include ExtremeStartup
include ExtremeStartup::Questions

class SteriaQuestion1 < TriviaQuestions

  def initialize(player)
    super(player, [
          ["hvor stor prosent kvinner jobber for Steria", "29"],
          ["hvilket land er Sterias hovedkontor", "Frankrike"],
        ])
  end
end

class SteriaQuestion2 < TriviaQuestions

  def initialize(player)
    super(player, [
          ["hvor mange jobber for Steria Norge", "650"],
          ["hvor er Sterias hovedkontor i Norden", "Oslo"],
          ["hvor mange jobber i Steria internasjonalt", "20000"],
          ["hva er tittelen av videoen du finner her: http://youtu.be/XUlcKR25PAQ", "Discover the Power of Sharing, Discover Steria"]
        ])
  end
end



warmup_round = [WarmupQuestion]
simple_round = [AdditionQuestion,MaximumQuestion,RememberMeQuestion,SteriaQuestion1]
medium_round = [MultiplicationQuestion, PrimesQuestion, SubtractionQuestion, SteriaQuestion2]
hard_round   = [WebshopQuestion] * 3 + [FibonacciQuestion, AdditionMultiplicationQuestion, MultiplicationAdditionQuestion]

WebServer.settings.default_question_delay = 5
WebServer.settings.question_factory = ExtremeStartup::GatedQuestionFactory.new([
  warmup_round,
  simple_round,
  simple_round + medium_round,
  medium_round + hard_round
])
WebServer.run!
