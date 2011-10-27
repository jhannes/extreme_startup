require_relative 'question'
require_relative 'questions/webshop_conversation'
require_relative 'questions/flight_time'

module ExtremeStartup
  class QuestionFactory
    attr_reader :round

    def initialize(question_types = nil, round = 1)
      @round = round
      @question_types = question_types || [
        AdditionQuestion,
        MaximumQuestion,
        MultiplicationQuestion, 
        SquareCubeQuestion,
        GeneralKnowledgeQuestion,
        PrimesQuestion,
        SubtractionQuestion,
        FibonacciQuestion,  
        PowerQuestion,
        AdditionAdditionQuestion,
        AdditionMultiplicationQuestion,
        MultiplicationAdditionQuestion
      ]
    end

    def next_question(player)
      available_question_types = @question_types[0..(@round * 2 - 1)]
      available_question_types.sample.new(player)
    end
    
    def advance_round
      @round += 1
    end  
  end

  class WarmupQuestion < Question
    def initialize(player)
      @player = player
    end
    def correct_answer
      @player.name
    end
    def score
      return 0 if @player.correct_answers(self.class) > 1
      return 10 if result == "correct"
      return 0 if @player.wrong_answers(self.class) > 1
      return -1
    end
    def as_text
      "what is your name"
    end
  end

  class GatedQuestionFactory
    def initialize(question_sets)
      @question_sets = question_sets
      @player_question_set_index = Hash.new(0)
    end
    def next_question(player)
      available_questions(player).sample.new(player)
    end
    def advance_round
    end
    def advance_player(player)
      index = @player_question_set_index[player]
      question_set = @question_sets[index]
      while index < @question_sets.length-1 and has_answered_all_questions(player, question_set)
        @player_question_set_index[player] += 1
        index = @player_question_set_index[player]
        question_set = @question_sets[index]
      end
    end
    def available_questions(player)
      advance_player(player)
      @question_sets[@player_question_set_index[player]]
    end
    def has_answered_all_questions(player, question_set)
      question_set.count { |q| player.correct_answers(q) == 0 } == 0
    end
  end
  
  class WarmupQuestionFactory < GatedQuestionFactory
    def initialize
      super([
        [WarmupQuestion],
        [AdditionQuestion,MaximumQuestion,RememberMeQuestion]])
    end
  end

  # TODO This should have several question sets, but it didn't advance to the last one!
  
  class WorkshopQuestionFactory < GatedQuestionFactory
    def initialize
      super([
          [RememberMeQuestion,
          ExtremeStartup::Questions::WebshopQuestion,
          ExtremeStartup::Questions::WebshopQuestion,
          ExtremeStartup::Questions::WebshopQuestion,
          ExtremeStartup::Questions::WebshopQuestion,
		  ExtremeStartup::Questions::FlightTime,
		  ExtremeStartup::Questions::FlightTime,
		  ExtremeStartup::Questions::FlightTime,
          DivisionQuestion,
          AdditionQuestion,
          MaximumQuestion,
          MultiplicationQuestion, 
          SquareCubeQuestion,
          GeneralKnowledgeQuestion,
          PrimesQuestion,
          SubtractionQuestion,
          FibonacciQuestion,  
          #PowerQuestion,
          #AdditionAdditionQuestion,
          AdditionMultiplicationQuestion,
          MultiplicationAdditionQuestion
        ]])
    end
  end
end
