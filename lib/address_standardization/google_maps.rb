# we would use Hpricot but it doesn't fully support XPath
#require 'libxml'
#require 'nokogiri'

require 'rubygems'
require 'hpricot'

module AddressStandardization
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
          
          address_str = "%s, %s, %s %s" % [
            address_info[:street],
            address_info[:city],
            (address_info[:state] || address_info[:province]),
            address_info[:zip]
          ]
          url = "http://maps.google.com/maps/geo?q=#{address_str.url_escape}&output=xml&key=#{GoogleMaps.api_key}&oe=utf-8"
          puts "URL: #{url}"
          uri = URI.parse(url)
          #req = Net::HTTP::Get.new(url)
          # do we need this?
          #req.basic_auth(uri.user, uri.password) if uri.userinfo
          #res = Net::HTTP.start(uri.host, uri.port) {|http| http.request(req) }
          res = Net::HTTP.get_response(uri)
          unless res.is_a?(Net::HTTPSuccess)
            File.open("test.xml", "w") {|f| f.write("(no response or response was unsuccessful)") }
            return nil 
          end
          xml = res.body
          File.open("test.xml", "w") {|f| f.write(xml) }
          xml = Hpricot::XML(xml)
          
          if xml.at("//kml/Response/Status/code").inner_text == "200"
            addr = {}
            
            addr[:street] = get_inner_text(xml, '//ThoroughfareName')
            addr[:city] = get_inner_text(xml, '//LocalityName')
            addr[:province] = addr[:state] = get_inner_text(xml, '//AdministrativeAreaName')
            addr[:zip] = addr[:postalcode] = get_inner_text(xml, '//PostalCodeNumber')
            addr[:country] = get_inner_text(xml, '//CountryName')
            #addr[:full_address] = get_inner_text(xml, '//address')
            
            # Translate accuracy into Yahoo-style token address, street, zip, zip+4, city, state, country
            # For Google, 1=low accuracy, 8=high accuracy
            #address_details = xml.at('//AddressDetails')
            #accuracy = address_details ? address_details.attributes['Accuracy'].to_i : 0
            #addr[:precision] = %w{unknown country state state city zip zip+4 street address}[accuracy]
            
            new(addr)
          else
            File.open("test.xml", "w") {|f| f.write("(no response or response was unsuccessful)") }
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