module AddressStandardization
  # See http://code.google.com/apis/maps/documentation/geocoding/
  # for documentation on Google's Geocoding API.
  class GoogleMaps < AbstractService
    class << self
      def api_key; end
      def api_key=(value)
        warn "The Google Maps API no longer requires a key, so you are free to remove `AddressStandardization::GoogleMaps.api_key = ...` from your code as it is now a no-op."
      end

    protected
      def get_live_response(address_info)
        # Much of this code was borrowed from GeoKit, specifically:
        # https://github.com/andre/geokit-gem/blob/master/lib/geokit/geocoders.rb#L530

        address_info = address_info.stringify_keys

        address_str = [
          address_info["street"],
          address_info["city"],
          (address_info["state"] || address_info["province"]),
          address_info["zip"]
        ].compact.join(" ")
        address_country = address_info["country"] || "US"

        resp = HTTParty.get("http://maps.google.com/maps/api/geocode/json",
          :query => {
            :sensor => 'false',
            :address => address_str,
            :bias => address_country.downcase
          }
        )
        data = resp.parsed_response
        AddressStandardization.debug <<EOT
[GoogleMaps] Response body:
--------------------------------------------------------------------------------
#{resp.body}
--------------------------------------------------------------------------------
EOT
        AddressStandardization.debug <<EOT
[GoogleMaps] Parsed response:
--------------------------------------------------------------------------------
#{data}
--------------------------------------------------------------------------------
EOT

        if data['results'].any? && data['status'] == "OK"
          result = data['results'].first
          addr = {}
          street = ["", ""]
          result['address_components'].each do |comp|
            case
            when comp['types'].include?("street_number")
              street[0] = comp['short_name']
            when comp['types'].include?("route")
              street[1] = comp['long_name']
            when comp['types'].include?("locality")
              addr[:city] = comp['long_name']
            when comp['types'].include?("administrative_area_level_1")
              addr[:state] = addr[:province] = comp['short_name']
            when comp['types'].include?("postal_code")
              addr[:postalcode] = addr[:zip] = comp['long_name']
            when comp['types'].include?("country")
              # addr[:country_code] = comp['short_name']
              addr[:country] = comp['long_name']
            when comp['types'].include?("administrative_area_level_2")
              addr[:county] = addr[:district] = comp['long_name']
            end
          end
          addr[:street] = street.join(" ").strip
          Address.new(addr)
        else
          return nil
        end
      end
    end
  end
end
