require 'spec_helper'

describe SynapseClient::MassPay do

  before(:each) do
    @customer_a     = get_dummy_customer
    @bank_account_a = @customer_a.add_bank_account(dummy_add_bank_account_info)

    @customer_b     = get_dummy_customer
    @bank_account_b = @customer_b.add_bank_account(dummy_add_bank_account_info)
  end

=begin

  curl -H "Content-Type: application/json" -d '{  
    "oauth_consumer_key":"dc236f737b6ba8ae6bcc4d786b221d15e51b1317",
    "mass_pays":[  
      {  
        "amount":"20",
        "trans_type":"0",
        "source_bank_id":"579",
        "dest_bank_id":"600"
      },
      {  
        "amount":"10",
        "trans_type":"0",
        "source_bank_id":"579",
        "dest_bank_id":"10"
      }
    ]
  }'
  https://sandbox.synapsepay.com/api/v2/masspay/add/

=end

  describe "adding a bunch of deposits to users" do
    it "should successfully return multiple mass pays" do

      params = { 
        :access_token => @customer_b.access_token,
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

      if !masspays.successful?
        puts "*** Error message: #{ masspays.error_msg }"
      end

      expect(masspays.successful?).to be true

      masspays.each do |mp|
        expect(mp.amount).to be_a Fixnum
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

end


