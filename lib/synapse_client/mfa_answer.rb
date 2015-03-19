
module SynapseClient
  class MfaAnswer

    attr_reader :answers
    attr_reader :bank_name
    attr_reader :bank_account_token

    def initialize(options = {})
      options.to_options!.compact

      @bank_name          = options[:bank_name]
      @bank_account_token = options[:account_token]
      @answers            = options[:answers]
    end


    def finish_linking(client)
      data = {
        :access_token => @bank_account_token,
        :bank         => @bank_name,
        :mfa          => @answers.join
      }

      request  = SynapseClient::Request.new("/api/v2/bank/mfa/", data, client)
      response = request.post

      if response.instance_of?(SynapseClient::Error)
        response
      elsif response["is_mfa"]
        SynapseClient::MFA.new(response["response"])
      else
        client.customer.add_bank_accounts response["banks"]
        client.customer.bank_accounts
      end
    end

  end
end


