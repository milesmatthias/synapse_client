# http://dev.synapsepay.com/

require "map"
require "restclient"
require "synapse_client/api_resource"
require "synapse_client/api_operations/response"
require "synapse_client/api_operations/list"
require "synapse_client/bank_account"
require "synapse_client/error"
require "synapse_client/merchant"
require "synapse_client/mfa"
require "synapse_client/order"
require "synapse_client/refreshed_tokens"
require "synapse_client/security_question"
require "synapse_client/customer"
require "synapse_client/util"
require "synapse_client/version"

module SynapseClient

  class << self
    attr_accessor :client_id, :client_secret
    attr_accessor :merchant_oauth_key, :merchant_email, :merchant_synapse_id
    attr_accessor :dev
    alias_method :dev?, :dev
  end

  def self.ensure_trailing_slash(url='')
    return url if url.empty?
    return url if url[-1] == "/"
    return url + "/"
  end

  def self.api_url(url='')
    base_api_url = "https://synapsepay.com"
    base_api_url = "https://sandbox.synapsepay.com" if dev?

    ret = base_api_url + ensure_trailing_slash(url)

    if dev?
      ret + "?is_dev=true"
    else
      ret
    end
  end

  def self.request(method, path, params={}, headers={}, client_id=nil, client_secret=nil, api_base_url=nil)

    #
      unless (client_id ||= @client_id) && (client_secret ||= @client_secret)
        # TODO - use a custom Error class here
        raise StandardError.new("You need to enter API credentials first.")
      end

      if client_id =~ /\s/ || client_secret =~ /\s/
        # TODO - use a custom Error class here
        raise StandardError.new("Your API credentials are invalid, as they contain whitespace.")
      end

    #
      url     = api_url(path)
      cookies = params.delete("cookies")

      case method.to_s.downcase.to_sym
      when :get, :head, :delete
        # Make params into GET parameters
        url += "#{URI.parse(url).query ? '&' : '?'}#{uri_encode(params)}" if params && params.any?
        payload = nil
      else
        if path.include?("oauth2")
          payload = params.to_query
          headers[:content_type] = "application/x-www-form-urlencoded"
        else
          payload = creds(client_id, client_secret).update(params)

          # dealing with some naming inconsistencies in the api
          payload[:oauth_consumer_key] = payload.delete(:access_token) if payload[:access_token]
          payload[:oauth_consumer_key] = payload.delete("access_token") if payload["access_token"]
          payload[:access_token] = payload.delete("bank_account_token") if payload["bank_account_token"]
          payload[:access_token] = payload.delete(:bank_account_token) if payload[:bank_account_token]

          payload = payload.to_json
          headers[:content_type] = :json
        end
      end

    #
      request_opts = {
        :headers => headers,
        :method => method, :open_timeout => 30,
        :payload => payload,
        :url => url, :timeout => 80, :cookies => cookies
      }

    #
      #begin
        response = execute_request(request_opts)
      # TODO: https://github.com/stripe/stripe-ruby/blob/master/lib/stripe.rb#L127
      #rescue 
      #end

      parse(response)
  end

  def self.creds(client_id, client_secret)
    {
      :client_id     => client_id,
      :client_secret => client_secret
    }
  end

  def self.execute_request(opts)
puts "\n"
puts "SynapseClient: About to send a request with the following opts:"
puts opts
puts "\n"
    RestClient::Request.execute(opts)
  end

  def self.uri_encode(params)
    Util.flatten_params(params).
      map { |k,v| "#{k}=#{Util.url_encode(v)}" }.join('&')
  end

  def self.parse(response)
    #begin
      body = JSON.parse(response.body)
    #rescue JSON::ParserError
    #   TODO
    #  raise general_api_error(response.code, response.body)
    #end

    APIOperations::Response.new(body, response.cookies)
  end

end

