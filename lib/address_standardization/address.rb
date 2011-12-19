module AddressStandardization
  class Address
    ATTRIBUTE_DEFS = [
      :street,
      :city,
      [:region, :state, :province],
      [:postal_code, :postcode, :zip],
      [:district, :county],
      :country
    ]
    ATTRIBUTE_NAMES = ATTRIBUTE_DEFS.flatten
    UNIQUE_ATTRIBUTE_NAMES = ATTRIBUTE_DEFS.map { |attr|
      Array === attr ? attr[0] : attr
    }

    ATTRIBUTE_DEFS.each do |duck|
      duck = [duck] unless Array === duck
      name, aliases = duck[0], duck[1..-1]

      attr_reader name
      define_method(:"#{name}=") do |value|
        instance_variable_set("@#{name}", value.to_s.upcase)
      end

      aliases.each do |a|
        alias_method a, name
        alias_method "#{a}=", "#{name}="
      end
    end

    def initialize(attrs={})
      attrs.symbolize_keys!
      _assert_valid_attrs!(attrs)
      attrs.each do |attr, value|
        __send__("#{attr}=", Helpers.strip_whitespace(value))
      end
    end

    def attributes
      UNIQUE_ATTRIBUTE_NAMES.inject({}) {|h,k| h[k] = __send__(k); h }
    end

    def ==(other)
      self.class === other && attributes == other.attributes
    end

    def _assert_valid_attrs!(attrs)
      # assume attrs's keys are already symbols
      valid_keys = ATTRIBUTE_NAMES
      invalid_keys = attrs.keys - valid_keys
      if invalid_keys.any?
        raise ArgumentError, "You gave invalid attributes: #{invalid_keys.join(', ')}. Valid attributes are: #{valid_keys.join(', ')}"
      end
    end
  end
end
