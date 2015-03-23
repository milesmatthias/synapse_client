
module SynapseClient
  class SecurityQuestion

    attr_reader :id
    attr_reader :text

    def initialize(options={})
      options = Map.new(options)

      @id   = options[:id]
      @text = options[:questions]
    end

  end
end

