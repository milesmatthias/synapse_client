module SynapseClient
  module APIOperations
    class Response
      attr_reader :data
      attr_reader :error_msg
      attr_reader :success
      attr_reader :cookies
      alias_method :successful?, :success

      def initialize(response, cookies=nil)
        response = Map.new(response)

        @success   = response.delete(:success)
        @error_msg = response.delete(:reason)
        @data      = response
        @cookies   = cookies
      end
    end
  end
end
