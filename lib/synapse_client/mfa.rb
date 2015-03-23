
module SynapseClient
  class MFA

    attr_reader :type
    attr_reader :questions
    attr_reader :bank_access_token

    def initialize(options={})
      options = Map.new(options)

      @bank_access_token = options[:access_token]
      @type              = options[:type]

      if @type == "questions"
        @questions = []
        questions  = options[:mfa]
        questions.each do |q|
          @questions.push q["question"]
        end
      end
    end

  end
end

