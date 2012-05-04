require 'rubygems'
require_relative 'lib/extreme_startup/web_server'
include ExtremeStartup
include ExtremeStartup::Questions


warmup_round = [WarmupQuestion]
warmup2_round = [AdditionQuestion,MultiplicationAdditionQuestion]
simple_round = [AdditionQuestion,MaximumQuestion,RememberMeQuestion,GeneralKnowledgeQuestion,AdditionAdditionQuestion]
medium_round = [MultiplicationQuestion, PrimesQuestion, SubtractionQuestion, DivisionQuestion]
advanced_round = [WebshopQuestion, SquareCubeQuestion]
hard_round   = [WebshopQuestion] * 2 + [FibonacciQuestion, AdditionMultiplicationQuestion, MultiplicationAdditionQuestion,AdditionAdditionQuestion]


WebServer.settings.default_question_delay =1
WebServer.settings.question_factory = ExtremeStartup::GatedQuestionFactory.new([
  warmup_round,
  warmup2_round,
  simple_round,
  simple_round + medium_round,
  medium_round + advanced_round,
  medium_round + advanced_round + hard_round
])
WebServer.run!
