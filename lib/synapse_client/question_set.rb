
module SynapseClient
  class QuestionSet

    attr_accessor :id, :questions

    def initialize(opts={})
      @id        = opts.id
      @questions = opts.questions.map{|q| Question.new(q)}
    end

    def successful?
      true
    end


    #
      class Question
        attr_reader :id, :question, :answers

        def initialize(opts = {})
          @id       = opts.id
          @question = opts.question
          @answers  = opts.answers.map{|a| Answer.new(a)}
        end
      end

    #
      class Answer
        attr_reader :id, :answer

        def initialize(opts = {})
          @id     = opts.id
          @answer = opts.answer
        end
      end

  end
end

