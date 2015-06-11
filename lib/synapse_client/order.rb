
module SynapseClient
  class Order < APIResource
    include SynapseClient::APIOperations::List

    attr_reader :status
    attr_reader :amount
    attr_reader :seller_email
    attr_reader :seller_id
    attr_reader :bank_pay
    attr_reader :bank_id
    attr_reader :note
    attr_reader :date_settled
    attr_reader :date
    attr_reader :ticket_number
    attr_reader :resource_uri
    attr_reader :account_type
    attr_reader :fee

    def initialize(options = {})
      options = Map.new(options)

      update_attributes(options)
    end

    def self.all(params={})
      orders = list(params, "recent").orders
      orders.map{|order| Order.new(order)}
    end

    def self.create(params={})
      response = SynapseClient.request(:post, url + "add", params)

      return response unless response.successful?
      Order.new(response.data.order)
    end

    def self.retrieve_endpoint
      "poll"
    end

    def self.status_object_for_key(key)
      case key
      when -1
        {status: "Queued", description: "Order has been queued by SynapsePay and we are currently investigating it."}
      when 0
        {status: "Queued", description: "Order has been queued and is waiting for merchant approval to process."}
      when 1
        {status: "Created", description: "Order created but still needs to be fetched from the bank account."}
      when 2
        {status: "In Progress", description: "The funds are being fetched from the sender’s bank account, in receiver’s Synapse account in 1-2 Business Days."}
      when 3
        {status: "Settled", description: "Transaction completed and the funds have been added to the receiver’s Synapse account."}
      when 4
        {status: "Refunded/Cancelled", description: "The order has been voided."}
      when 5
        {status: "Returned", description: "Received an ACH return from the sender’s bank account. Which means someone is in trouble."}
      else
        {status: "Unknown", description: "Unknown status key. The API may have changed."}
      end
    end

    def status_label
      Order.status_object_for_key(status)[:status]
    end
    def status_description
      Order.status_object_for_key(status)[:description]
    end

    def retrieve_params
      {:order_id => @id}
    end

    def update_attributes(options)
      @status        = options[:status]
      @amount        = options[:amount]
      @seller_email  = options[:seller_email]
      @bank_pay      = options[:bank_pay]
      @bank_id       = options[:bank_id]
      @note          = options[:note]
      @date_settled  = options[:date_settled]
      @date          = options[:date]
      @id            = options[:id]
      @ticket_number = options[:ticket_number]
      @resource_uri  = options[:resource_uri]
      @account_type  = options[:account_type]
      @fee           = options[:fee]
      @seller_id     = options[:seller_id] || options[:seller].delete("seller_id") rescue nil
    end

  end
end

