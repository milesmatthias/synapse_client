
module SynapseClient
  class BankAccount < APIResource
    include SynapseClient::APIOperations::List

    attr_accessor :name_on_account, :nickname
    attr_accessor :date, :bank_name, :resource_uri
    attr_accessor :account_class, :account_type
    attr_accessor :routing_number_string, :account_number_string
    attr_accessor :is_active, :is_buyer_default, :is_seller_default, :is_verified

    def initialize(options = {})
      @account_class         = options[:account_class]
      @account_number_string = options[:account_number_string]
      @account_type          = options[:account_type]
      @bank_name             = options[:bank_name]
      @date                  = options[:date]
      @id                    = options[:id] || options[:bank_id]
      @is_active             = options[:is_active]
      @is_buyer_default      = options[:is_buyer_default]
      @is_seller_default     = options[:is_seller_default]
      @is_verified           = options[:is_verified]
      @name_on_account       = options[:name_on_account]
      @nickname              = options[:nickname]
      @resource_uri          = options[:resource_uri]
      @routing_number_string = options[:routing_number_string]
    end

    def self.api_resource_name
      "bank"
    end

    def self.all(params={})
      bank_accounts = list(params).banks
      bank_accounts.map{|ba| BankAccount.new(ba)}
    end

    def self.add(params={})
      response = SynapseClient.request(:post, url + "add", params)
      return response unless response.successful?
      BankAccount.new(response.data.bank)
    end

    def self.link(params={})
      response = SynapseClient.request(:post, url + "login", params)
      return response unless response.successful?

      if response.data["is_mfa"]
        MFA.new(response.data.response)
      else
        response.data.banks.map do |bank|
          BankAccount.new(bank)
        end
      end
    end

    def self.finish_linking(params={})
      unless params[:bank]
        raise ArgumentError.new("You must include the bank name when responding to an MFA question.")
      end
      unless params[:bank_account_token]
        raise ArgumentError.new("You must include the bank account token when responding to an MFA question.")
      end
      unless params[:mfa]
        raise ArgumentError.new("You must include the answer(s) when responding to an MFA question.")
      end

      response = SynapseClient.request(:post, url + "mfa", params)
      return response unless response.successful?

      if response.data["is_mfa"]
        MFA.new(response.data.response)
      else
        response.data.banks.map do |bank|
          BankAccount.new(bank)
        end
      end
    end

  end
end
