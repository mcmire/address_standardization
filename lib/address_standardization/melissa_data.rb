# encoding: utf-8

module AddressStandardization
  class MelissaData
    class BaseAddress < AbstractAddress
      class << self
      protected
        def standardize(address_info, action, attrs_to_fields)
          is_canada = (address_info[:country] == "CANADA")
          addr = new(address_info)
          
          url = "http://www.melissadata.com/lookups/#{action}"
          params = []
          attrs_to_fields.each do |attr, field|
            key, val = field, addr.send(attr)
            params << "#{key}=#{val.url_escape}" if val
          end
          url << "?" + params.join("&")
          url << "&FindAddress=Submit"
          
          #puts "URL: <#{url}>"
          
          fields = nil
          WWW::Mechanize.new do |ua|
            results_page = ua.get(url)
            
            ##puts "** Response **"
            ##puts
            ##puts results_page.body

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
            fields = [ street.upcase, city.upcase, state.upcase, zip.upcase ]
          end
          fields
        end
      end
    end
    
    class USAddress < BaseAddress
      self.valid_keys = %w(street city state zip country)
      
      def self.standardize(address_info)
        address_info[:country] = "USA"
        if fields = super(address_info, "AddressVerify.asp", :street => 'Address', :city => 'city', :state => 'state', :zip => 'zip')
          street, city, state, zip = fields
          new(:street => street, :city => city, :state => state, :zip => zip, :country => address_info[:country])
        end
      end
    end
    
    class CanadianAddress < BaseAddress
      self.valid_keys = %w(street city province postalcode country)
      
      def self.standardize(address_info)
        address_info[:country] = "CANADA"
        if fields = super(address_info, "CanadianAddressVerify.asp", :street => 'Street', :city => 'city', :province => 'Province', :postalcode => 'Postcode')
          street, city, province, postalcode = fields
          new(:street => street, :city => city, :province => province, :postalcode => postalcode, :country => address_info[:country])
        end
      end
    end
  end
end