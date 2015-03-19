
require 'synapse_client/error'

module SynapseClient
  class Request

    attr_reader :customer_access_token
    attr_reader :customer_refresh_token
    attr_reader :client_id
    attr_reader :client_secret
    attr_reader :device_id
    attr_reader :path
    attr_reader :response
    attr_reader :payload
    attr_reader :client
    attr_accessor :headers

    def initialize(path, data = {}, client = nil)
      client = SynapseClient::Client.new if client.nil?

      @path                   = path || ""
      @payload                = data || {}
      @customer_refresh_token = client.customer.refresh_token
      @client_id              = client.merchant.client_id
      @client_secret          = client.merchant.client_secret
      @client                 = client
      @customer_access_token  = client.customer.access_token
      @device_id              = client.merchant.device_id
    end

    def post

      data                      = @payload
      data[:client_id]          = @client_id
      data[:client_secret]      = @client_secret
      data[:oauth_consumer_key] = @customer_access_token
      data[:device_id]          = @device_id

      if @path.include?("oauth2")
        payload = data.to_query
        content_type = "application/x-www-form-urlencoded"
      else
        payload = data.to_json
        content_type = :json
      end

      data_to_log = data.dup

      unless @client.is_dev
        data_to_log[:oauth_consumer_key] = "FILTERED" if data_to_log[:oauth_consumer_key].present?
        data_to_log[:access_token]       = "FILTERED" if data_to_log[:access_token].present?
        data_to_log[:client_secret]      = "FILTERED" if data_to_log[:client_secret].present?
        data_to_log[:username]           = "FILTERED" if data_to_log[:username].present?
        data_to_log[:password]           = "FILTERED" if data_to_log[:password].present?
        data_to_log[:pin]                = "FILTERED" if data_to_log[:pin].present?
      end

      # FIXME
      # Rails.logger.debug "About to post to #{ url_for_path(@path) } with payload: #{ data_to_log }"

      if @headers.instance_of?(Hash)
        headers_to_send = @headers.dup
      else
        headers_to_send = {}
      end
      headers_to_send[:content_type] = content_type

      begin
        response = RestClient.post(url_for_path(@path), payload, headers_to_send)
        response = JSON.parse(response)

        response_to_log = response.dup
        response_to_log["access_token"]  = "FILTERED" if response_to_log["access_token"].present?
        response_to_log["refresh_token"] = "FILTERED" if response_to_log["refresh_token"].present?

        # FIXME
        # Rails.logger.debug("Just got response from Synapse: #{ response_to_log }")

        if response["success"]
          response
        else
          SynapseClient::Error.new(response, self)
        end
      rescue => e
        SynapseClient::Error.new(e, self)
      end
    end

    def get
    end

  private
    def url_for_path(path = "")
      if @client.is_dev
        ["https://sandbox.synapsepay.com", path, "?is_dev=true"].join
      else
        ["https://synapsepay.com", path].join
      end
    end

  end
end

