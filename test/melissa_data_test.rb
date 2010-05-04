require 'test_helper'

class MelissaDataTest < Test::Unit::TestCase
  shared "production mode tests" do
    test "Valid US address (implicit country)" do
      addr = AddressStandardization::MelissaData.standardize_address(
        :street => "1 Infinite Loop",
        "city" => "Cupertino",
        :state => "CA"
      )
      addr.should == AddressStandardization::Address.new(
        "street" => "1 INFINITE LOOP",
        "city" => "CUPERTINO",
        "state" => "CA",
        "province" => "CA",
        "zip" => "95014-2083",
        "postalcode" => "95014-2083",
        "country" => "USA"
      )
    end
  
    test "Valid US address (explicit country)" do
      addr = AddressStandardization::MelissaData.standardize_address(
        :street => "1 Infinite Loop",
        :city => "Cupertino",
        "state" => "CA",
        "country" => "USA"
      )
      addr.should == AddressStandardization::Address.new(
        "street" => "1 INFINITE LOOP",
        "city" => "CUPERTINO",
        "state" => "CA",
        "province" => "CA",
        "zip" => "95014-2083",
        "postalcode" => "95014-2083",
        "country" => "USA"
      )
    end
  
    test "Invalid US address" do
      addr = AddressStandardization::MelissaData.standardize_address(
        :street => "123 Imaginary Lane",
        :city => "Some Town",
        :state => "AK"
      )
      addr.should == nil
    end
  
    test "Valid Canadian address" do
      addr = AddressStandardization::MelissaData.standardize_address(
        "street" => "55 Cordova St E #415",
        :city => "Vancouver",
        "province" => "BC",
        # FIXME: This must be postalcode, it doesn't work with zip...
        :postalcode => "V6A0A5",
        :country => "CANADA"
      )
      addr.should == AddressStandardization::Address.new(
        "street" => "415-55 CORDOVA ST E",
        "city" => "VANCOUVER",
        "state" => "BC",
        "province" => "BC",
        "postalcode" => "V6A 0A5",
        "zip" => "V6A 0A5",
        "country" => "CANADA"
      )
    end
  
    test "Invalid Canadian address" do
      addr = AddressStandardization::MelissaData.standardize_address(
        :street => "123 Imaginary Lane",
        :city => "Some Town",
        :province => "BC"
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
      AddressStandardization::MelissaData.canned_response = :success
      addr = AddressStandardization::MelissaData.standardize_address(
        :street => "123 Imaginary Lane",
        :city => "Some Town",
        :province => "BC"
      )
      addr.should == AddressStandardization::Address.new(
        :street => "123 Imaginary Lane",
        :city => "Some Town",
        :province => "BC"
      )
      AddressStandardization::MelissaData.canned_response = nil
    end
    
    test "Valid address (block)" do
      AddressStandardization::MelissaData.with_canned_response(:success) do
        addr = AddressStandardization::MelissaData.standardize_address(
          :street => "123 Imaginary Lane",
          :city => "Some Town",
          :province => "BC"
        )
        addr.should == AddressStandardization::Address.new(
          :street => "123 Imaginary Lane",
          :city => "Some Town",
          :province => "BC"
        )
      end
    end
    
    test "Invalid address (before and after)" do
      AddressStandardization::MelissaData.canned_response = :failure
      addr = AddressStandardization::MelissaData.standardize_address(
        :street => "123 Imaginary Lane",
        :city => "Some Town",
        :province => "BC"
      )
      addr.should == nil
      AddressStandardization::MelissaData.canned_response = nil
    end
    
    test "Invalid address (block)" do
      AddressStandardization::MelissaData.with_canned_response(:failure) do
        addr = AddressStandardization::MelissaData.standardize_address(
          :street => "123 Imaginary Lane",
          :city => "Some Town",
          :province => "BC"
        )
        addr.should == nil
      end
    end
  end
end