module SynapseClient
  module APIOperations
    module List
      module ClassMethods
        def list(params={}, list_action="show")
          response = SynapseClient.request(:post, url + list_action, params)
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
