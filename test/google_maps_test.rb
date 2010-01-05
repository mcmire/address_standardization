require 'test_helper'

AddressStandardization::GoogleMaps.api_key = "ABQIAAAALHg3jKnK9wN9K3_ArJA6TxSTZ2OgdK08l2h0_gdsozNQ-6zpaxQvIY84J7Mh1fAHQrYGI4W27qKZaw"

class GoogleMapsTest < Test::Unit::TestCase
  shared "production mode tests" do
    test "A valid US address" do
      addr = AddressStandardization::GoogleMaps.standardize_address(
        "street" => "1600 Amphitheatre Parkway",
        :city => "Mountain View",
        :state => "CA"
      )
      addr.should == AddressStandardization::Address.new(
        "street" => "1600 AMPHITHEATRE PKWY",
        "city" => "MOUNTAIN VIEW",
        "state" => "CA",
        "province" => "CA",
        "postalcode" => "94043",
        "zip" => "94043",
        "country" => "USA"
      )
    end
  
    test "A valid Canadian address" do
      addr = AddressStandardization::GoogleMaps.standardize_address(
        :street => "1770 Stenson Boulevard",
        :city => "Peterborough",
        "province" => "ON"
      )
      addr.should == AddressStandardization::Address.new(
        "street" => "1770 STENSON BLVD",
        "city" => "PETERBOROUGH",
        "state" => "ON",
        "province" => "ON",
        "postalcode" => "K9K",
        "zip" => "K9K",
        "country" => "CANADA"
      )
    end
  
    test "An invalid address" do    
      addr = AddressStandardization::GoogleMaps.standardize_address(
        :street => "123 Imaginary Lane",
        :city => "Some Town",
        :state => "AK"
      )
      addr.should == nil
    end
  end
  
  context "With test mode explicitly false" do
    setup do
      AddressStandardization.test_mode = false
    end
    uses "production mode tests"
  end
  
  context "With test mode implicitly false" do
    setup do
      AddressStandardization.test_mode = nil
    end
    uses "production mode tests"
  end
  
  context "With test mode true" do
    setup do
      AddressStandardization.test_mode = true
    end
    
    test "Valid address (before and after)" do
      AddressStandardization::GoogleMaps.canned_response = :success
      addr = AddressStandardization::GoogleMaps.standardize_address(
        :street => "123 Imaginary Lane",
        :city => "Some Town",
        :state => "AK"
      )
      addr.should == AddressStandardization::Address.new(
        :street => "123 Imaginary Lane",
        :city => "Some Town",
        :state => "AK"
      )
      AddressStandardization::GoogleMaps.canned_response = nil
    end
    
    test "Valid address (block)" do
      AddressStandardization::GoogleMaps.with_canned_response(:success) do
        addr = AddressStandardization::GoogleMaps.standardize_address(
          :street => "123 Imaginary Lane",
          :city => "Some Town",
          :state => "AK"
        )
        addr.should == AddressStandardization::Address.new(
          :street => "123 Imaginary Lane",
          :city => "Some Town",
          :state => "AK"
        )
      end
    end
    
    test "Invalid address (before and after)" do
      AddressStandardization::GoogleMaps.canned_response = :failure
      addr = AddressStandardization::GoogleMaps.standardize_address(
        :street => "123 Imaginary Lane",
        :city => "Some Town",
        :state => "AK"
      )
      addr.should == nil
      AddressStandardization::GoogleMaps.canned_response = nil
    end
    
    test "Invalid address (block)" do
      AddressStandardization::GoogleMaps.with_canned_response(:failure) do
        addr = AddressStandardization::GoogleMaps.standardize_address(
          :street => "123 Imaginary Lane",
          :city => "Some Town",
          :state => "AK"
        )
        addr.should == nil
      end
    end
  end
end