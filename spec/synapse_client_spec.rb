require 'spec_helper'

describe SynapseClient do

  before(:each) do
    SynapseClient.client_id     = test_credentials[:client_id]
    SynapseClient.client_secret = test_credentials[:client_secret]
    SynapseClient.dev           = test_credentials[:dev]
  end


  describe "api keys should be stored" do
    it 'stores the client_id on the top level module' do
      expect(SynapseClient.client_id).to eq(test_credentials[:client_id])
    end

    it 'stores the client_secret on the top level module' do
      expect(SynapseClient.client_secret).to eq(test_credentials[:client_secret])
    end

    it 'stores that dev is true' do
      expect(SynapseClient.dev).to eq(test_credentials[:dev])
      expect(SynapseClient.dev?).to eq(test_credentials[:dev])
    end
  end


  describe "url generation is correct" do
    it "should have the is_dev query param" do
      expect(SynapseClient.api_url).to eq("https://sandbox.synapsepay.com?is_dev=true")
    end

    it "should have the sandbox domain" do
      expect(SynapseClient.api_url).to match("https://sandbox.synapsepay.com")
    end

    it "should append a path to the url with a trailing slash" do
      expect(SynapseClient.api_url("/foo")).to match("https://sandbox.synapsepay.com/foo/")
    end
  end


  describe "base request method" do
    it "should raise an error when api keys are absent" do
      SynapseClient.client_id = nil
      expect { SynapseClient.request("get", "users") }.to raise_error
    end

    it "should raise an error when api keys contain whitespace" do
      SynapseClient.client_id = " foo bar "
      expect { SynapseClient.request("get", "users") }.to raise_error
    end

    it "should be able to do a basic get of bank statuses" do
      response = SynapseClient.request("get", "/api/v2/bankstatus/show/")

      expect(response).to be_an(SynapseClient::APIOperations::Response)
      expect(response.successful?).to be true

      expect(response.data.banks).to be_an(Array)
      expect(response.data.banks.count).to be > 0
    end
  end

end

