[![Build Status](https://travis-ci.org/milesmatthias/synapse_client.png?branch=master)](https://travis-ci.org/milesmatthias/synapse_client)  [![Gem Version](https://badge.fury.io/rb/synapse_client.png)](http://badge.fury.io/rb/synapse_client) [![Coverage Status](https://coveralls.io/repos/milesmatthias/synapse_client/badge.png)](https://coveralls.io/r/milesmatthias/synapse_client)

# synapse_client

A ruby client for the SynapsePay.com API.

I ripped originally wrote this in a rails app of mine and stripped this out. There's some work left to do to really make it a true ruby gem. See that in the todo section.

## Usage

## TODO

* This is written with the perspective of being the merchant. This gem doesn't support marketplace payments yet, although SynapsePay does support that.
* This is also written with the assumption that a customer has no knowledge of their Synapse account. This means:
  * that this gem says "Customers" when Synapse says "Users"
  * all orders are bank pay orders
  * customers do not have passwords
* Logging
* Refresh access tokens
* MFAs
* Callbacks?

# Links

* dev.synapsepay.com
* rubygems.org/gems/synapse_client

