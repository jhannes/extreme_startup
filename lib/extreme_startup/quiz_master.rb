require_relative 'question_factory'
require 'uri'
require 'logger'

module ExtremeStartup

  class QuizMaster
    
    def initialize(player, scoreboard, question_factory, default_delay = 5)
      @player = player
      @scoreboard = scoreboard
      @question_factory = question_factory
      @default_delay = default_delay
    end
    
    def player_passed?(response)
      response.to_s.downcase.strip == "pass"
    end
  
    def start
      log = Logger.new("extreme_startup-#$$.log")
      while true
        question = @question_factory.next_question(@player)
        question.ask(@player)
        puts "For player #{@player}\n#{question.display_result}" unless $silence_logging
        log.info("Player: #{@player}|#{question.log_result}") unless $silence_logging
        @scoreboard.increment_score_for(@player, question.score)
        @player.log_result(question.id, question.result, question.score)
        sleep question.delay_before_next(@default_delay)
      end
    end
  end

end
