
module SynapseClient
  class SecurityQuestion

    attr_reader :id
    attr_reader :text

    def initialize(options)
      options.to_options!.compact

      @id   = options[:id]
      @text = options[:questions]
    end

  end
end

