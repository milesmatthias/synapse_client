
module SynapseClient
  class Customer < APIResource

    attr_accessor :email, :fullname, :phonenumber, :ip_address
    attr_accessor :access_token, :refresh_token, :expires_in
    attr_accessor :username
    attr_accessor :force_create

    def initialize(options = {})
      options = Map.new(options)

      @id            = options[:id]            || options[:user_id]
      @email         = options[:email]
      @fullname      = options[:fullname]      || options[:name]
      @phonenumber   = options[:phonenumber]   || options[:phone_number]
      @ip_address    = options[:ip_address]

      @access_token  = options[:access_token]
      @refresh_token = options[:refresh_token]
      @expires_in    = options[:expires_in]
      @username      = options[:username]

      @force_create  = options[:force_create]
    end

    def self.api_resource_name
      "user" # see README.md
    end

    def self.create(opts={})
      Customer.new(opts).create
    end

    def create
      headers  = {"REMOTE_ADDR" => @ip_address}
      response = SynapseClient.request(:post, url + "create", to_hash, headers)

      return response unless response.successful?
      update_attributes(response.data)
    end

    def self.retrieve(access_token, refresh_token)
      response = Customer.get_user({
              :access_token  => access_token,
              :refresh_token => refresh_token
            })

      unless response.successful? # refresh tokens & try once more.
        new_tokens = Customer.refresh_tokens(access_token, refresh_token)
        return new_tokens if new_tokens.instance_of?(SynapseClient::Error)
        return Customer.get_user({
            :access_token  => new_tokens.access_token,
            :refresh_token => new_tokens.refresh_token,
            :expires_in    => new_tokens.expires_in
          })
      end

      response
    end

  #
    def add_kyc_info(opts={})
      response = SynapseClient.request(:post, "/api/v2/user/ssn/add", opts.merge({
        :access_token => @access_token
      }))

      unless response.data["question_set"].nil?
        return SynapseClient::QuestionSet.new(response.data.question_set)
      else
       return response
      end
    end

    def verify_kyc_info(opts={})
      response = SynapseClient.request(:post, "/api/v2/user/ssn/answer", opts.merge({
        :access_token => @access_token
      }))

      return response
    end

  # TODO
    def login
      # use http://synapsepay.readme.io/v1.0/docs/authentication-login
    end

  #
    def bank_accounts
      BankAccount.all({:access_token => @access_token})
    end
    def primary_bank_account
      @bank_accounts.select{|ba| ba.is_buyer_default}.first
    end

    def add_bank_account(params={})
      BankAccount.add(params.merge({
        :access_token => @access_token,
        :fullname     => @fullname
      }))
    end

    def link_bank_account(params={})
      BankAccount.link(params.merge({
        :access_token => @access_token
      }))
    end

    def finish_linking_bank_account(params={})
      BankAccount.finish_linking(params.merge({
        :access_token => @access_token
      }))
    end

  #
    def orders
      Order.all({:access_token => @access_token})
    end

    def add_order(params={})
      if SynapseClient.merchant_synapse_id.nil?
        raise ArgumentError.new("You need to set SynapseClient.merchant_synapse_id before you can submit orders.")
      else
        Order.create(params.merge({
          :access_token => @access_token,
          :seller_id    => params[:seller_id] || SynapseClient.merchant_synapse_id,
          :bank_pay     => "yes"        # see README.md
        }))
      end
    end

    def self.refresh_tokens(access_token, refresh_token)
      rt = SynapseClient::RefreshedTokens.new({
        :old_access_token  => access_token,
        :old_refresh_token => refresh_token
      }).refresh_old_tokens

      return rt if rt.instance_of?(SynapseClient::Error)

      Map.new({
        :access_token  => rt.new_access_token,
        :refresh_token => rt.new_refresh_token,
        :expires_in    => rt.new_expires_in
      })
    end

    def self.get_user(opts={})
      response = SynapseClient.request(:post, url + "show", {:access_token => opts[:access_token]})

      return response unless response.successful?

      opts.delete(:expires_in) if opts[:expires_in].nil?

      Customer.new(response.data.user.merge(opts))
    end

private
    def update_attributes(data)
      @id            = data.user_id
      @access_token  = data.access_token rescue data.oauth_consumer_key
      @refresh_token = data.refresh_token
      @expires_in    = data.expires_in
      @username      = data.username
      return self
    end

  end
end
