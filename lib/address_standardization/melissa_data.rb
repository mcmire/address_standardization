require 'rubygems'
require 'mechanize'

module AddressStandardization
  class MelissaData
    class BaseAddress < AbstractAddress
      cattr_inheritable :start_url
      
      def initialize(address_info)
        raise NotImplementedError, "You must define start_url" unless self.class.start_url
        super(address_info)
      end
      
      class << self
      protected
        def standardize(address_info, action, attrs_to_fields)
          is_canada = (action =~ /Canadian/)
          addr = new(address_info)
          fields = nil
          WWW::Mechanize.new do |ua|
            form_page = ua.get(start_url)
            form = form_page.form_with(:action => action) do |form|
              attrs_to_fields.each do |attr, field|
                form[field] = addr.send(attr)
              end
            end
            results_page = form.submit(form.buttons.first)
            
            puts "** Response **"
            puts
            puts results_page.body

            table = results_page.search("form")[2].next_sibling.next_sibling
            status_th = table.search(is_canada ? "td" : "th")[0]
            return unless status_th && status_th.inner_text =~ /Address Verified/
            main_td = table.search("tr:eq(#{is_canada ? 1 : 2})/td:eq(1)")
            strongs = main_td.search("strong")
            street = strongs.first.inner_text
            strongs[1].search("a:gt(0)").remove
            city, state, zip = strongs[1].inner_html.strip_newlines.strip_html.split(/(?:&\w+;)+/)
            fields = [ street.upcase, city.upcase, state.upcase, zip.upcase ]
          end
          fields
        end
      end
    end
    
    class USAddress < BaseAddress
      self.start_url = 'http://www.melissadata.com/lookups/AddressVerify.asp'
      self.valid_keys = %w(street city state zip)
      
      def self.standardize(address_info)
        if fields = super(address_info, "AddressVerify.asp", :street => 'Address', :city => 'city', :state => 'state', :zip => 'zip')
          street, city, state, zip = fields
          new(:street => street, :city => city, :state => state, :zip => zip)
        end
      end
    end
    
    class CanadianAddress < BaseAddress
      self.start_url = 'http://www.melissadata.com/lookups/CanadianAddressVerify.asp'
      self.valid_keys = %w(street city province postalcode)
      
      def self.standardize(address_info)
        if fields = super(address_info, "CanadianAddressVerify.asp", :street => 'Street', :city => 'city', :province => 'Province', :postalcode => 'Postcode')
          street, city, province, postalcode = fields
          new(:street => street, :city => city, :province => province, :postalcode => postalcode)
        end
      end
    end
  end
end