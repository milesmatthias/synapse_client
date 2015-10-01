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
      expect(@customer.expires_in).to be_a String
      expect(@customer.username).to be_a String
    end

    it "should successfully return a customer when a dup user is created and force_create is used" do
      @dup_data = @dummy_customer_data.merge(:force_create => "no")
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
      expect(@customer_dup.expires_in).to be_a String
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

  describe "editing a customer" do
    it "should successfully update a user's info" do

      customer = SynapseClient::Customer.retrieve(@customer.access_token, @customer.refresh_token)

      expect(customer).to be_a SynapseClient::Customer

      new_pass = "changeme"

      response = customer.edit_info(new_password: new_pass)

      expect(response.success).to eq true
      expect(response.data.user.email).to eq customer.email
    end
  end

  describe "refreshing and retrieving customer" do
    it "should successfully get new oauth consumer key, refresh token, and expires in." do
      customer = SynapseClient::Customer.retrieve(@customer.access_token, @customer.refresh_token)

      old_access_token  = @customer.access_token.dup
      old_refresh_token = @customer.refresh_token.dup

      response = SynapseClient::Customer.refresh_tokens(old_access_token, old_refresh_token)

      expect(response).to be_a Map

      expect(response.access_token).to be_a String
      expect(response.refresh_token).to be_a String
      expect(response.expires_in).to be_a String

      expect(response.access_token).not_to be eq(old_access_token)
      expect(response.refresh_token).not_to be eq(old_refresh_token)
    end

    it "should successfully retrieve a customer with a broken access token" do
      old_access_token  = @customer.access_token.dup
      old_refresh_token = @customer.refresh_token.dup

      customer = SynapseClient::Customer.retrieve("accexpired", @customer.refresh_token)

      expect(customer).to be_a SynapseClient::Customer

      expect(customer.access_token).to be_a String
      expect(customer.refresh_token).to be_a String
      expect(customer.expires_in).to be_a String

      expect(customer.access_token).not_to be eq(old_access_token)
      expect(customer.refresh_token).not_to be eq(old_refresh_token)
    end
  end

  describe "adding failure kyc info for a customer" do
    it "should return an error" do
      response = @customer.add_kyc_info(failure_kyc_info)

      expect(response.successful?).to be false
      expect(response.error_msg).to be_a String
    end
  end

  describe "adding unverified kyc info for a customer" do
    it "should return ssn questions" do
      response = @customer.add_kyc_info(unverified_kyc_info)

      expect(response.successful?).to be true

      expect(response).to be_a SynapseClient::QuestionSet

      expect(response.questions).to be_an Array
      expect(response.questions).not_to be_empty
    end
  end

  describe "verifying ssn with question answers" do
    it "should return success" do
      response        = @customer.add_kyc_info(unverified_kyc_info)

      expect(response).to be_a SynapseClient::QuestionSet

      verify_response = @customer.verify_kyc_info(kyc_verify_values(response))

      expect(verify_response.successful?).to be true
      expect(verify_response.success).to be true
    end
  end

  describe "adding successful kyc info for a customer" do
    it "should return success" do
      response = @customer.add_kyc_info(verified_kyc_info)

      expect(response.successful?).to be true
      expect(response.success).to be true
    end
  end

end

