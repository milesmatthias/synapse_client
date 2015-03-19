
module SynapseClient
  class Customer

    attr_reader   :email
    attr_reader   :fullname
    attr_reader   :password
    attr_reader   :phonenumber
    attr_accessor :access_token
    attr_accessor :refresh_token
    attr_accessor :token_expires_in
    attr_accessor :bank_accounts
    attr_reader   :ip_address

    def initialize(options = {})
      options.to_options!.compact

      @email            = options[:email]
      @fullname         = options[:fullname]      || options[:name]
      @password         = options[:password]
      @phonenumber      = options[:phone_number]  || ENV["SYNAPSE_MERCHANT_PHONENUMBER"]
      @access_token     = options[:access_token]
      @refresh_token    = options[:refresh_token]
      @token_expires_in = options[:expires_in]
      @bank_accounts    = []
      @ip_address       = options[:ip_address]
    end

    def primary_bank_account
      @bank_accounts.select{|ba| ba.is_buyer_default}.first
    end

    def link_account(options = {}, client)
      options.to_options!.compact

      data = {
        :bank               => options[:bank_name],
        :password           => options[:password],
        :pin                => options[:pin] || "1234",
        :username           => options[:username]
      }

      request  = SynapseClient::Request.new("/api/v2/bank/login/", data, client)
      response = request.post

      if response.instance_of?(SynapseClient::Error)
        response
      elsif response["is_mfa"]
        SynapseClient::MFA.new(response["response"])
      else
        add_bank_accounts response["banks"]
        @bank_accounts
      end
    end
    def unlink_account(options = {}, client)
      data = {
        :bank_id => options.delete(:bank_id),
      }

      request  = SynapseClient::Request.new("/api/v2/bank/delete/", data, client)
      request.post
    end

    def add_bank_accounts(bank_accounts)
      bank_accounts = [] if bank_accounts.nil?
      bank_accounts.each do |ba|
        @bank_accounts.push(SynapseClient::BankAccount.new(ba)) unless ba.empty?
      end
    end

    def get_bank_accounts(client)
      request  = SynapseClient::Request.new("/api/v2/bank/show/", {}, client)
      response = request.post
      unless response.instance_of?(SynapseClient::Error)
        response["banks"].map{|b| SynapseClient::BankAccount.new(b)}
      end
    end

    def self.create(options = {})
      options.to_options!.compact

      data = {
        :email       => options[:email],
        :fullname    => options[:fullname] || options[:name] || [options[:first_name], options[:last_name]].join(' '),
        :password    => options[:password],
        :phonenumber => options[:phone_number] || ENV["SYNAPSE_MERCHANT_PHONENUMBER"]
      }

      request         = SynapseClient::Request.new("/api/v2/user/create/", data)
      request.headers = {"REMOTE_ADDR" => options[:ip_address]}
      response        = request.post
    end

  end
end
