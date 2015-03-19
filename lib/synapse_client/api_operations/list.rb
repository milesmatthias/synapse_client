module SynapseClient
  module APIOperations
    module List
      module ClassMethods
        def list(params={})
          response = SynapseClient.request(:post, url + "show", params)
          return response unless response.successful?
          response.data
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
