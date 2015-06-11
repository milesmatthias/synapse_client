require 'spec_helper'

describe SynapseClient::Order do

  before(:each) do
    @customer         = get_dummy_customer
    @bank             = @customer.add_bank_account(dummy_add_bank_account_info)
    @amount_to_charge = rand(1..1000)
  end

  describe "getting orders for a customer" do
    it "should return an empty array" do
      orders = @customer.orders

      expect(orders).to be_an(Array)
      expect(orders.count).to eq(0)
    end
  end

  describe "adding an order" do
    it "should successfully return an order." do
      order = @customer.add_order({
        :amount  => @amount_to_charge,
        :bank_id => @bank.id
      })
      expect(order).to be_a SynapseClient::Order

      expect(order.amount).to eq(@amount_to_charge)
      expect(order.id).to be_a Fixnum
      expect(order.status).to be_a Fixnum
    end
  end

  describe "retrieving an order" do
    it "should successfully return an order." do
      new_order = @customer.add_order({
        :amount  => @amount_to_charge,
        :bank_id => @bank.id
      })
      order     = SynapseClient::Order.retrieve(new_order.id)

      expect(order).to be_a SynapseClient::Order

      expect(order.status).to be_a Fixnum
      expect(order.status_label).to be_a String
      expect(order.status_description).to be_a String
    end
  end

end



