require 'rubygems'
require_relative 'lib/extreme_startup/web_server'
include ExtremeStartup
include ExtremeStartup::Questions

warmup_round = [WarmupQuestion]
warmup2_round = [AdditionQuestion]
simple_round = [AdditionQuestion,MaximumQuestion,RememberMeQuestion,GeneralKnowledgeQuestion]

WebServer.settings.default_question_delay = 5
WebServer.settings.question_factory = ExtremeStartup::GatedQuestionFactory.new([
  warmup_round,
  warmup2_round,
  simple_round,
])
WebServer.run!
