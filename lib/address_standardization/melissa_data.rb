# encoding: utf-8

module AddressStandardization
  class MelissaData < AbstractService
    class << self
    protected
      def get_live_response(address_info)
        address_info = address_info.stringify_keys
        
        is_canada = (address_info["country"].to_s.upcase == "CANADA")
        addr = Address.new(address_info)
        
        url = "http://www.melissadata.com/lookups/#{action(is_canada)}"
        params = []
        attrs_to_fields(is_canada).each do |attr, field|
          key, val = field, address_info[attr]
          params << "#{key}=#{val.url_escape}" if val
        end
        url << "?" + params.join("&")
        url << "&FindAddress=Submit"
        
        #puts "URL: <#{url}>"
        
        attrs = {:country => (is_canada ? "CANADA" : "USA")}
        Mechanize.new do |ua|
          AddressStandardization.debug "[MelissaData] Hitting URL: #{url}"
          results_page = ua.get(url)
          AddressStandardization.debug "[MelissaData] Response body:"
          AddressStandardization.debug "--------------------------------------------------"
          AddressStandardization.debug results_page.body
          AddressStandardization.debug "--------------------------------------------------"

          table = results_page.search("table.Tableresultborder")[1]
          return unless table
          status_row = table.at("span.Titresultableok")
          return unless status_row && status_row.inner_text =~ /Address Verified/
          main_td = table.search("tr:eq(#{is_canada ? 2 : 3})/td:eq(2)")
          main_td_s = main_td.inner_html
          main_td_s.encode!("utf-8") if main_td_s.respond_to?(:encode!)
          street_part, city_state_zip_part = main_td_s.split("<br>")[0..1]
          street = street_part.strip_html.strip_whitespace
          if main_td_s.respond_to?(:encode!)
            # ruby 1.9
            separator = city_state_zip_part.include?("&#160;&#160;") ? "&#160;&#160;" : "  "
          else
            # ruby 1.8
            separator = "\240\240"
          end
          city, state, zip = city_state_zip_part.strip_html.split(separator)
          attrs[:street] = street.upcase
          attrs[:city] = city.upcase
          attrs[:province] = attrs[:state] = state.upcase
          attrs[:postalcode] = attrs[:zip] = zip.upcase
        end
        Address.new(attrs)
      end
      
      def action(is_canada)
        is_canada ? "CanadianAddressVerify.asp" : "AddressVerify.asp"
      end
      
      def attrs_to_fields(is_canada)
        if is_canada
          {"street" => 'Street', "city" => 'city', "province" => 'Province', "postalcode" => 'Postcode'}
        else
          {"street" => 'Address', "city" => 'city', "state" => 'state', "zip" => 'zip'}
        end
      end
    end
  end
end