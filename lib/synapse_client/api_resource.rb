
module SynapseClient
  class APIResource

    attr_accessor :id

    def self.class_name
      self.name.split('::')[-1]
    end

    def self.api_resource_name
      class_name.downcase
    end

    def to_hash
      hash = {}
      instance_variables.each do |var|
        value = instance_variable_get(var)
        hash[var[1..-1].to_sym] = value if value
      end
      hash
    end

    def self.url
      if self == APIResource
        raise NotImplementedError.new('APIResource is an abstract class.  You should perform actions on its subclasses (Customer, Bank Account, Order, etc.)')
      end
      "/api/v2/#{CGI.escape( api_resource_name )}/"
    end

    def url
      if self.id
        "#{self.class.url}/#{CGI.escape(id)}"
      else
        self.class.url
      end
    end

    def refresh
      response, opts = SynapseClient.request(:get, url, @retrieve_params)
      refresh_from(response, opts)
    end

    def self.retrieve(id, opts={})
      opts.merge(:id => id)
      instance = self.new(opts)
      instance.refresh
      instance
    end

  end
end
