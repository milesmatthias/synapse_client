module Stripe
  module APIOperations
    module Create
      module ClassMethods
        def create(params={}, opts={})
          response, opts = SynapseClient.request(:post, url, params, opts)
          response
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
