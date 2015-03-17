
module SynapseClient
  class BankAccount

    attr_accessor :account_class
    attr_accessor :account_number_string
    attr_accessor :account_type
    attr_accessor :bank_name
    attr_accessor :date
    attr_accessor :id
    attr_accessor :is_active
    attr_accessor :is_buyer_default
    attr_accessor :is_seller_default
    attr_accessor :is_verified
    attr_accessor :name_on_account
    attr_accessor :nickname
    attr_accessor :resource_uri
    attr_accessor :routing_number_string

    def initialize(options = {})
      options.to_options!.compact

      @account_class         = options[:account_class]
      @account_number_string = options[:account_number_string]
      @account_type          = options[:account_type]
      @bank_name             = options[:bank_name]
      @date                  = options[:date]
      @id                    = options[:id]
      @is_active             = options[:is_active]
      @is_buyer_default      = options[:is_buyer_default]
      @is_seller_default     = options[:is_seller_default]
      @is_verified           = options[:is_verified]
      @name_on_account       = options[:name_on_account]
      @nickname              = options[:nickname]
      @resource_uri          = options[:resource_uri]
      @routing_number_string = options[:routing_number_string]
    end

  end
end
