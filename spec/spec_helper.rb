require 'coveralls'
Coveralls.wear!

require 'pry'
require 'synapse_client'


def test_credentials
  {
    :client_id     => "e06fa0f143a267c2ed8e",
    :client_secret => "f578105bf9ae03d9310e0af6f4637c1bf363998b",
    :dev           => true
  }
end


def dummy_user_data
  hex = SecureRandom.hex

  {
    :email       => "foo+" + hex + "@example.com",
    :fullname    => "Foo Bar " + hex,
    :phonenumber => "5555555555"
  }
end

def get_dummy_user_tokens
  response = SynapseClient::Customer.create(dummy_user_data)

  Map.new({
    :access_token  => response.access_token,
    :refresh_token => response.refresh_token
  })
end


