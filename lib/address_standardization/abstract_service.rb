module AddressStandardization
  class AbstractService
    class << self
      attr_accessor :canned_response

      def standardize_address(address_info)
        if AddressStandardization.test_mode?
          get_canned_response(address_info)
        else
          get_live_response(address_info)
        end
      end

      def with_canned_response(response, &block)
        old_response = self.canned_response
        self.canned_response = response
        ret = yield
        self.canned_response = old_response
        ret
      end

    protected
      def get_canned_response(address_info)
        response = (self.canned_response ||= :success)
        response == :success ? Address.new(address_info) : nil
      end

      def get_live_response
        raise NotImplementedError
      end

      def logger
        AddressStandardization.logger
      end
    end

    self.canned_response = :success
  end
end
