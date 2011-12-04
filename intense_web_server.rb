require 'rubygems'

require_relative 'lib/extreme_startup/web_server'
ExtremeStartup::WebServer.settings.default_question_delay = 1
ExtremeStartup::WebServer.settings.question_factory = ExtremeStartup::WorkshopQuestionFactory.new
ExtremeStartup::WebServer.run!
