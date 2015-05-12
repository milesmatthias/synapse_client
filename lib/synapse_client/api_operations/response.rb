module SynapseClient
  module APIOperations
    class Response
      attr_reader :data
      attr_reader :error_msg
      attr_reader :cookies
      attr_reader :status_code
      attr_reader :success
      alias_method :successful?, :success

      def initialize(response, cookies=nil)
        response = Map.new(response)

        @status_code = response.delete(:status_code)
        @success     = response.delete(:success)
        @error_msg   = response.delete(:reason)
        @data        = response
        @cookies     = cookies
      end
    end
  end
end
