require 'spec_helper'

describe SynapseClient::Customer do

  before(:each) do
    @dummy_customer_data = dummy_customer_data
    @customer = SynapseClient::Customer.create(@dummy_customer_data)
  end


  describe "creating a customer" do
    it "should successfully return a customer object with tokens and other info." do
      expect(@customer).to be_a SynapseClient::Customer

      expect(@customer.successful?).to be true

      expect(@customer.email).to be @dummy_customer_data.email
      expect(@customer.fullname).to be @dummy_customer_data.fullname
      expect(@customer.phonenumber).to be @dummy_customer_data.phonenumber
      expect(@customer.ip_address).to be @dummy_customer_data.ip_address

      expect(@customer.id).to be_a Fixnum
      expect(@customer.access_token).to be_a String
      expect(@customer.refresh_token).to be_a String
      expect(@customer.expires_in).to be_a Fixnum
      expect(@customer.username).to be_a String
    end

    it "should successfully return a customer when a dup user is created and force_create is used" do
      @dup_data = @dummy_customer_data.merge(:force_create => true)
      @customer_dup = SynapseClient::Customer.create(@dup_data)

      expect(@customer_dup).to be_a SynapseClient::Customer

      expect(@customer_dup.successful?).to be true

      expect(@customer_dup.email).to be @dup_data.email
      expect(@customer_dup.fullname).to be @dup_data.fullname
      expect(@customer_dup.phonenumber).to be @dup_data.phonenumber
      expect(@customer_dup.ip_address).to be @dup_data.ip_address

      expect(@customer.id).to be_a Fixnum
      expect(@customer_dup.access_token).to be_a String
      expect(@customer_dup.refresh_token).to be_a String
      expect(@customer_dup.expires_in).to be_a Fixnum
      expect(@customer_dup.username).to be_a String
    end
  end

  describe "retrieving a customer" do
    it "should successfully return a customer object with tokens and other info." do
      customer = SynapseClient::Customer.retrieve(@customer.access_token, @customer.refresh_token)

      expect(customer).to be_a SynapseClient::Customer

      expect(customer.email).to eq @dummy_customer_data.email
      expect(customer.fullname).to eq @dummy_customer_data.fullname
      expect(customer.phonenumber).to eq @dummy_customer_data.phonenumber
      expect(customer.username).to be_a String

      expect(customer.id).to be_a Fixnum
      expect(customer.access_token).to be_a String
      expect(customer.refresh_token).to be_a String
    end
  end

end

