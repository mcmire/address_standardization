require 'hpricot'

module AddressStandardization
  # See <http://code.google.com/apis/maps/documentation/geocoding/>
  module GoogleMaps
    class << self
      attr_accessor :api_key
    end
    
    class Address < AbstractAddress
      self.valid_keys = %w(street city state province postalcode zip country full_address precision)
      
      class << self
        # much of this code was borrowed from GeoKit, thanks...
        def standardize(address_info)
          raise "API key not specified.\nCall AddressStandardization::GoogleMaps.api_key = '...' before you call .standardize()." unless GoogleMaps.api_key
          
          address_str = [
            address_info[:street],
            address_info[:city],
            (address_info[:state] || address_info[:province]),
            address_info[:zip]
          ].join(" ")
          url = "http://maps.google.com/maps/geo?q=#{address_str.url_escape}&output=xml&key=#{GoogleMaps.api_key}&oe=utf-8"
          ##puts "Calling Google Maps URL: #{url}"
          uri = URI.parse(url)
          res = Net::HTTP.get_response(uri)
          unless res.is_a?(Net::HTTPSuccess)
            #File.open("test.xml", "w") {|f| f.write("(no response or response was unsuccessful)") }
            return nil 
          end
          xml = res.body
          #File.open("test.xml", "w") {|f| f.write(xml) }
          xml = Hpricot::XML(xml)
          
          if xml.at("//kml/Response/Status/code").inner_text == "200"
            addr = {}
            
            addr[:street]   = get_inner_text(xml, '//ThoroughfareName').to_s
            addr[:city]     = get_inner_text(xml, '//LocalityName').to_s
            addr[:province] = addr[:state] = get_inner_text(xml, '//AdministrativeAreaName').to_s
            addr[:zip]      = addr[:postalcode] = get_inner_text(xml, '//PostalCodeNumber').to_s
            addr[:country]  = get_inner_text(xml, '//CountryName').to_s
            
            return nil if addr[:street] =~ /^\s*$/ or addr[:city]  =~ /^\s*$/
            
            new(addr)
          else
            #File.open("test.xml", "w") {|f| f.write("(no response or response was unsuccessful)") }
            nil
          end
        end
        
      private
        def get_inner_text(xml, xpath)
          lambda {|x| x && x.inner_text.upcase }.call(xml.at(xpath))
        end
      end
    end # Address
  end # GoogleMaps
end # AddressStandardization