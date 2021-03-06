require 'spec_helper'

describe SynapseClient::MassPay do

  before(:each) do
    @customer_a     = get_dummy_customer
    @bank_account_a = @customer_a.add_bank_account(dummy_add_bank_account_info)

    @customer_b     = get_dummy_customer
    @bank_account_b = @customer_b.add_bank_account(dummy_add_bank_account_info)
  end

=begin
  # TODO
  describe "adding a bunch of deposits to users" do
    it "should successfully return multiple mass pays" do

      params = { 
        :access_token => @customer_a.access_token,
        :mass_pays => [{
          :amount => 20.to_s,
          :trans_type => 0.to_s,
          :source_bank_id => @bank_account_a.id.to_s,
          :dest_bank_id => @bank_account_b.id.to_s
        },{
          :amount => 10.to_s,
          :trans_type => 0.to_s,
          :source_bank_id => @bank_account_a.id.to_s,
          :dest_bank_id => @bank_account_b.id.to_s
        }]
      }

      masspays = SynapseClient::MassPay.create(params)

      if !masspays.instance_of?(Array)
        puts "*** Error message: #{ masspays.error_msg }"
      end

      expect(masspays).to be_an Array

      masspays.each do |mp|
        expect(mp.amount).to be_a Float
        expect(mp.trans_type).to be_a Fixnum
        expect(mp.source_bank_id).to be_a Fixnum
        expect(mp.dest_bank_id).to be_a Fixnum

        expect(mp.amount).to eq(20).or eq(10)
        expect(mp.trans_type).to eq(0)
        expect(mp.source_bank_id).to eq(@bank_account_a.id)
        expect(mp.dest_bank_id).to eq(@bank_account_b.id)
      end

    end
  end
=end

end


