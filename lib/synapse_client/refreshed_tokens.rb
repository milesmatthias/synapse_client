
module SynapseClient
  class RefreshedTokens

    attr_reader :old_access_token
    attr_reader :old_refresh_token
    attr_reader :new_access_token
    attr_reader :new_refresh_token

    def initialize(options = {})
      options = Map.new(options)

      @old_access_token = options[:old_access_token]
      @old_refresh_token = options[:old_refresh_token]
    end

    def refresh_old_tokens
      data = {
        :grant_type => "refresh_token",
        :refresh_token => @old_refresh_token
      }

      request = SynapseClient::Request.new("/oauth2/access_token", data)
      response = request.post

      unless response.instance_of?(SynapseClient::Error)
        self.new_access_token  = response["access_token"]
        self.new_refresh_token = response["refresh_token"]

        return self
      else
        return response
      end

    end

  end
end

