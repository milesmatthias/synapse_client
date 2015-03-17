
module SynapseClient
  class Error

    attr_reader :message
    attr_reader :title
    attr_reader :code
    attr_reader :exception
    attr_reader :request

    def initialize(exception, request)
      @exception = exception
      @request   = request

      #
        begin
          @message = @exception["reason"] || @exception["message"]
          @title   = @exception["title"]
        rescue => e
          # FIXME
          # Rails.logger.error("Something went wrong with interacting with Synapse: #{ @exception.message }")
          return
        end

      #
        if @message.present? && @message.match(/error.*oauth.*authentication/i).present?
          refreshed_tokens = SynapseClient::RefreshedTokens.new({
              :old_access_token => @request.user_access_token,
              :old_refresh_token => @request.user_refresh_token
            })

          refreshed_tokens.refresh_old_tokens
        end

    end

    def msg
      (title || message).to_s
    end

  end
end
