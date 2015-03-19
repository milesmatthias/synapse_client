require 'spec_helper'

describe SynapseClient::Order do

  before(:each) do
    @bank             = get_dummy_bank
    @amount_to_charge = rand(1..1000)
    @new_order        = @bank.add_order({:amount => @amount_to_charge})
  end


  describe "adding an order" do
    it "should successfully return an order." do
      expect(@new_order).to be_a SynapseClient::Order

      expect(@new_order.amount).to eq(@amount_to_charge)
      expect(@new_order.id).to be_a Fixnum
      expect(@new_order.status).to be_a String
    end
  end

  describe "retrieving an order" do
    it "should successfully return an order." do
      order = SynapseClient::Order.retrieve(@new_order.id)

      expect(order).to be_a SynapseClient::Order

      expect(order.amount).to eq(@amount_to_charge)
      expect(order.id).to be_a Fixnum
      expect(order.status).to be_a String
    end
  end

end



