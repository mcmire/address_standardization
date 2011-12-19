# encoding: utf-8

module AddressStandardization
  class MelissaData < AbstractService
    class << self
    protected
      def get_live_response(address_info)
        address_info = address_info.stringify_keys

        is_canada = (address_info["country"].to_s.upcase == "CANADA")

        if is_canada
          raise "The MelissaData adapter doesn't work for Canadian addresses currently. This is a known issue and will be fixed in a future release."
        end

        url = "http://www.melissadata.com/lookups/#{action(is_canada)}"
        params = []
        attrs_to_fields(is_canada).each do |attr, field|
          key, val = field, address_info[attr]
          params << "#{key}=#{Helpers.url_escape(val)}" if val
        end
        url << "?" + params.join("&")
        url << "&FindAddress=Submit"

        addr = Address.new(
          :country => (is_canada ? "Canada" : "United States")
        )
        ua = Mechanize.new
        logger.debug "[MelissaData] Hitting URL: #{url}"
        results_page = ua.get(url)
        logger.debug "[MelissaData] Response body:"
        logger.debug "--------------------------------------------------"
        logger.debug results_page.body
        logger.debug "--------------------------------------------------"

        table = results_page.at("table.Tableresultborder")
        unless table
          logger.debug "Couldn't find table"
          return nil
        end
        status_row = table.at("div.Titresultableok")
        unless status_row
          logger.debug "Couldn't find status_row"
          return nil
        end
        unless status_row.inner_text =~ /Address Verified/
          logger.debug "Address not verified"
          return nil
        end
        main_td = table.search("tr:eq(#{is_canada ? 2 : 3})/td:eq(2)")
        main_td_s = main_td.inner_html
        main_td_s.encode!("utf-8") if main_td_s.respond_to?(:encode!)
        street_part, city_state_zip_part = main_td_s.split("<br>")[0..1]
        street = Helpers.strip_whitespace(Helpers.strip_html(street_part))
        if main_td_s.respond_to?(:encode!)
          # ruby 1.9
          separator = city_state_zip_part.include?("&#160;&#160;") ? "&#160;&#160;" : "  "
        else
          # ruby 1.8
          separator = "\240\240"
        end
        county_row = table.search('tr.tdresul01')[4]
        county = county_row.inner_text.match(/County ([A-Za-z ]+)/)[1].strip
        city, state, zip = Helpers.strip_html(city_state_zip_part).split(separator)
        addr.street = street.upcase
        addr.city = city.upcase
        addr.province = state.upcase
        addr.postal_code = zip.upcase
        addr.district = county.upcase

        return addr
      end

      def action(is_canada)
        is_canada ? "CanadianAddressVerify.asp" : "AddressVerify.asp"
      end

      def attrs_to_fields(is_canada)
        if is_canada
          {'street' => 'Street', 'city' => 'city', 'province' => 'Province', 'postalcode' => 'Postcode'}
        else
          {'street' => 'Address', 'city' => 'city', 'state' => 'state', 'zip' => 'zip'}
        end
      end
    end
  end
end
