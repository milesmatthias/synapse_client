
module SynapseClient
  class RefreshedTokens

    attr_accessor :old_access_token
    attr_accessor :old_refresh_token
    attr_accessor :new_access_token
    attr_accessor :new_refresh_token
    attr_accessor :new_expires_in

    def initialize(options = {})
      options = Map.new(options)

      @old_access_token  = options[:old_access_token]
      @old_refresh_token = options[:old_refresh_token]
    end

    def refresh_old_tokens
      data = {
        :grant_type => "refresh_token",
        :refresh_token => @old_refresh_token
      }

      response = SynapseClient.request(:post, "/api/v2/user/refresh", data)

      unless response.instance_of?(SynapseClient::Error)
        @new_access_token  = response.data["oauth_consumer_key"]
        @new_refresh_token = response.data["refresh_token"]
        @new_expires_in    = response.data["expires_in"]

        return self
      else
        return response
      end
    end

  end
end

