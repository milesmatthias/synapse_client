require 'spec_helper'

describe SynapseClient::BankAccount do

  before(:each) do
    @customer = get_dummy_customer
  end

  describe "listing bank accounts" do
    it "should return an empty array when a customer has 0 bank accounts" do
      bank_accounts = @customer.bank_accounts

      expect(bank_accounts).to be_an(Array)
      expect(bank_accounts.count).to eq(0)
    end
  end

  describe "adding a bank account" do
    it "should successfully return the bank account." do
      bank_account = @customer.add_bank_account(dummy_add_bank_account_info)

      expect(bank_account).to be_a SynapseClient::BankAccount

      expect(bank_account.account_number_string).to be_a String
      expect(bank_account.routing_number_string).to be_a String
      expect(bank_account.nickname).to be_a String
      expect(bank_account.account_type).to be_a Fixnum
      expect(bank_account.account_class).to be_a Fixnum
    end
  end

  describe "linking a bank account" do
    it "should successfully return bank accounts." do
      bank_accounts = @customer.link_bank_account(dummy_link_bank_account_info)

      expect(bank_accounts).to be_a Array
      expect(bank_accounts.count).to be > 0

      bank_accounts.each do |ba|
        expect(ba.account_number_string).to be_a String
        expect(ba.routing_number_string).to be_a String
        expect(ba.bank_name).to be_a String
        expect(ba.nickname).to be_a String
        expect(ba.name_on_account).to be_a String
        expect(ba.account_type).to be_a Fixnum
        expect(ba.account_class).to be_a Fixnum
      end
    end
  end

end


