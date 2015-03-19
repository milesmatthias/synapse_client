require 'coveralls'
Coveralls.wear!

require 'pry'
require 'synapse_client'


#
  def test_credentials
    Map.new({
      :client_id     => "e06fa0f143a267c2ed8e",
      :client_secret => "f578105bf9ae03d9310e0af6f4637c1bf363998b",
      :dev           => true
    })
  end
  SynapseClient.client_id     = test_credentials.client_id
  SynapseClient.client_secret = test_credentials.client_secret
  SynapseClient.dev           = test_credentials.dev


#
# Most of this dummy data is taken from the examples at dev.synapsepay.com.

#
  def dummy_customer_data
    hex = SecureRandom.hex(4)

    Map.new({
      :email       => "foo+" + hex + "@example.com",
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
      :routing_num   => "123456789",
      :nickname      => "Example bank account",
      :account_type  => "1",
      :account_class => "1"
    })
  end

  def dummy_link_bank_account_info
    Map.new({
      :username => "someusername",
      :password => "somepassword",
      :pin      => "1234",
      :bank     => "Bank of America"
    })
  end

