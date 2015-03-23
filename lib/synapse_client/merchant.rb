

module SynapseClient
  class Merchant

    attr_accessor :client_id
    attr_accessor :client_secret
    attr_accessor :oauth_merchant_key
    attr_accessor :merchant_email
    attr_accessor :device_id

    def initialize(options ={})
      options = Map.new(options)

      @client_id          = options[:client_id]          || ENV["SYNAPSE_CLIENT_ID"]
      @client_secret      = options[:client_secret]      || ENV["SYNAPSE_CLIENT_SECRET"]
      @oauth_merchant_key = options[:oauth_merchant_key] || ENV["SYNAPSE_OAUTH_MERCHANT_KEY"]
      @merchant_email     = options[:merchant_email]     || ENV["SYNAPSE_MERCHANT_EMAIL"]
      @device_id          = options[:device_id]          || ENV["SYNAPSE_DEVICE_ID"]
    end

  end
end

