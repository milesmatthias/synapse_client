require 'spec_helper'

describe SynapseClient::BankAccount do

  before(:each) do
    SynapseClient.client_id     = test_credentials[:client_id]
    SynapseClient.client_secret = test_credentials[:client_secret]
    SynapseClient.dev           = test_credentials[:dev]
  end


  describe "adding a bank account" do
    it "should successfully return tokens and other info." do
      tokens = get_dummy_user_tokens

      expect(response.success).to be true
      expect(response.expires_in).to be_a Fixnum

      expect(response.access_token).to be_a String
      expect(response.reason).to be_a String
      expect(response.refresh_token).to be_a String
      expect(response.username).to be_a String

      expect(response.access_token).not_to be_nil
      expect(response.reason).not_to be_nil
      expect(response.refresh_token).not_to be_nil
      expect(response.username).not_to be_nil
    end
  end


  describe "linking a bank account" do
    it "should successfully return tokens and other info." do
      tokens = get_dummy_user_tokens

      expect(response.success).to be true
      expect(response.expires_in).to be_a Fixnum

      expect(response.access_token).to be_a String
      expect(response.reason).to be_a String
      expect(response.refresh_token).to be_a String
      expect(response.username).to be_a String

      expect(response.access_token).not_to be_nil
      expect(response.reason).not_to be_nil
      expect(response.refresh_token).not_to be_nil
      expect(response.username).not_to be_nil
    end
  end

end


