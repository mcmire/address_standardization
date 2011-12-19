module AddressStandardization
  class StandardizationError < StandardError; end

  # TODO: Rewrite this class so keys are attr_accessorized
  class Address
    class << self
      attr_accessor :valid_keys
    end
    self.valid_keys = %w(street city state province zip postalcode country county district)

    attr_reader :address_info

    def initialize(address_info)
      raise NotImplementedError, "You must define valid_keys" unless self.class.valid_keys
      raise ArgumentError, "No address given!" if address_info.empty?
      address_info = address_info.stringify_keys
      validate_keys(address_info)
      standardize_values!(address_info)
      @address_info = address_info
    end

    def validate_keys(hash)
      # assume keys are already stringified
      invalid_keys = hash.keys - self.class.valid_keys
      unless invalid_keys.empty?
        raise ArgumentError, "Invalid keys: #{invalid_keys.join(', ')}. Valid keys are: #{self.class.valid_keys.join(', ')}"
      end
    end

    def method_missing(name, *args)
      name = name.to_s
      if self.class.valid_keys.include?(name)
        if args.empty?
          @address_info[name]
        else
          @address_info[name] = standardize_value(args.first)
        end
      else
        super(name.to_sym, *args)
      end
    end

    def ==(other)
      other.kind_of?(self.class) && @address_info == other.address_info
    end

  private
    def standardize_values!(hash)
      hash.each {|k,v| hash[k] = standardize_value(v) }
    end

    def standardize_value(value)
      value ? value.strip_whitespace : ""
    end
  end
end
