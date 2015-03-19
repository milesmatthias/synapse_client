[![Build Status](https://travis-ci.org/milesmatthias/synapse_client.png?branch=master)](https://travis-ci.org/milesmatthias/synapse_client)  [![Gem Version](https://badge.fury.io/rb/synapse_client.png)](http://badge.fury.io/rb/synapse_client) [![Coverage Status](https://coveralls.io/repos/milesmatthias/synapse_client/badge.png)](https://coveralls.io/r/milesmatthias/synapse_client)

# synapse_client

A ruby client for the SynapsePay.com API.

I ripped originally wrote this in a rails app of mine and stripped this out. There's some work left to do to really make it a true ruby gem. See that in the todo section.

## Notes

* This is written with the perspective of being the merchant. This gem doesn't support marketplace payments yet, although SynapsePay does support that.
* This is also written with the assumption that a customer has no knowledge of their Synapse account. This means:
  * that this gem says "Customers" when Synapse says "Users"
  * all orders are bank pay orders
  * customers do not have passwords

## Usage

_See the specs for the most up to date usage demo._

#### configuration

```ruby
  SynapseClient.client_id           = "e06fa0f143a267c2ed8e"
  SynapseClient.client_secret       = "f578105bf9ae03d9310e0af6f4637c1bf363998b"
  SynapseClient.merchant_synapse_id = 1
  SynapseClient.dev                 = true
```

#### create a customer

```ruby
  SynapseClient::Customer.create({
    :email       => "foo@example.com",
    :fullname    => "Foo Bar,
    :phonenumber => "5555555555",
    :ip_address  => "8.8.8.8"
  })
```

#### retrieve a customer

```ruby
  SynapseClient::Customer.retrieve("_customer_access_token_")
```

#### list bank accounts for a customer

```ruby
  @customer.bank_accounts
```

#### add a bank account to a customer with just account & routing number

```ruby
  @customer.add_bank_account({
    :account_num   => "1111111111",
    :routing_num   => "084000026",
    :nickname      => "Example bank account",
    :account_type  => "1",
    :account_class => "1"
  })
```

#### link a bank account to a customer with bank username/password

```ruby
  @customer.link_bank_account({
    :username => "synapse_good",
    :password => "test1234",
    :pin      => "1234",
    :bank     => "Bank of America"
  })
```

#### get recent orders for a customer

```ruby
  @customer.orders
```

#### add an order for a customer

```ruby
  @customer.add_order({
    :amount  => 500,      # $500 USD
    :bank_id => 1
  })
```

#### retrieve an order

```ruby
  SynapseClient::Order.retrieve(4)
```

## TODO

* Logging
* Refresh access tokens
* MFAs
* Callbacks?

# Links

* [dev.synapsepay.com](http://dev.synapsepay.com)
* [rubygems.org/gems/synapse_client](https://rubygems.org/gems/synapse_client)

