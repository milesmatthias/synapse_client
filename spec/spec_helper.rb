require 'coveralls'
Coveralls.wear!

require 'pry'
require 'synapse_client'


#
  def test_credentials
    Map.new({
      :client_id              => "e06fa0f143a267c2ed8e",
      :client_secret          => "f578105bf9ae03d9310e0af6f4637c1bf363998b",
      :merchant_synapse_id    => 536,
      :merchant_oauth_token   => "16688788f22d8b46a83711b42ad9b0dec39b09ce",
      :merchant_refresh_token => "37e6f092e3c9a5ad0c1a2f2c62fec6ab8cb44808",
      :merchant_username      => "0537fa5d0cb94aaea9e79900bc0cab",
      :dev                    => true
    })
  end
  SynapseClient.client_id           = test_credentials.client_id
  SynapseClient.client_secret       = test_credentials.client_secret
  SynapseClient.merchant_synapse_id = test_credentials.merchant_synapse_id
  SynapseClient.dev                 = test_credentials.dev


#
# Most of this dummy data is taken from the examples at dev.synapsepay.com.

#
  def dummy_customer_data
    hex = SecureRandom.hex(4)
    hex[0] = hex[0].upcase

    Map.new({
      :email       => "foo+" + hex.downcase + "@example.com",
      :fullname    => "Foo Bar " + hex,
      :phonenumber => sprintf('%010d', rand(10**10)),
      :ip_address  => Array.new(4){rand(256)}.join('.')
    })
  end

  def get_dummy_customer
    SynapseClient::Customer.create(dummy_customer_data)
  end

#
  def dummy_add_bank_account_info
    Map.new({
      :account_num   => "1111111111",
      :routing_num   => "084000026",
      :nickname      => "Example bank account",
      :account_type  => "1",
      :account_class => "1"
    })
  end

  def dummy_link_bank_account_info
    Map.new({
      :username => "synapse_good",
      :password => "test1234",
      :pin      => "1234",
      :bank     => "Bank of America"
    })
  end

  def dummy_finish_linking_bank_account_info
    Map.new({
      :mfa  => "some_answer",
      :bank => "Bank of America"
    })
  end

  def get_dummy_bank
    
    SynapseClient::Customer.create(dummy_customer_data)
  end


