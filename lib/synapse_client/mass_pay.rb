
module SynapseClient
  class MassPay < APIResource

    attr_reader :amount
    attr_reader :trans_type
    attr_reader :source_bank_id
    attr_reader :dest_bank_id


    def initialize(options = {})
      options = Map.new(options)

      update_attributes(options)
    end

    def self.create(params={})
      response = SynapseClient.request(:post, url + "add", params)

      return response unless response.successful?
      response.data.masspays.map do |mp|
        MassPay.new(mp)
      end
    end


    def update_attributes(options)
      @amount         = options[:amount]
      @trans_type     = options[:trans_type]
      @source_bank_id = options[:source_bank_id]
      @dest_bank_id   = options[:dest_bank_id]
    end

  end
end
