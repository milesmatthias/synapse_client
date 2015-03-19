module SynapseClient
  module APIOperations
    class Response
      attr_reader :data
      attr_reader :error_msg
      attr_reader :success
      alias_method :successful?, :success

      def initialize(response)
        response = Map.new(response)

        @success   = response.delete(:success)
        @error_msg = response.delete(:reason)
        @data      = response
      end
    end
  end
end
