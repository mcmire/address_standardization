require 'test_helper'

class MelissaDataTest < Test::Unit::TestCase
  test "Valid US address (implicit country)" do
    addr = AddressStandardization::MelissaData::Address.standardize(
      :street => "1 Infinite Loop",
      "city" => "Cupertino",
      :state => "CA"
    )
    addr.should == AddressStandardization::MelissaData::Address.new(
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
    addr = AddressStandardization::MelissaData::Address.standardize(
      :street => "1 Infinite Loop",
      :city => "Cupertino",
      "state" => "CA",
      "country" => "USA"
    )
    addr.should == AddressStandardization::MelissaData::Address.new(
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
    addr = AddressStandardization::MelissaData::Address.standardize(
      :street => "123 Imaginary Lane",
      :city => "Some Town",
      :state => "AK"
    )
    addr.should == nil
  end
  
  test "Valid Canadian address" do
    addr = AddressStandardization::MelissaData::Address.standardize(
      "street" => "3025 Clayhill Rd",
      :city => "Mississauga",
      "province" => "ON",
      :country => "CANADA"
    )
    addr.should == AddressStandardization::MelissaData::Address.new(
      "street" => "3025 CLAYHILL RD",
      "state" => "ON",
      "province" => "ON",
      "city" => "MISSISSAUGA",
      "zip" => "L5B 4L2",
      "postalcode" => "L5B 4L2",
      "country" => "CANADA"
    )
  end
  
  test "Invalid Canadian address" do
    addr = AddressStandardization::MelissaData::Address.standardize(
      :street => "123 Imaginary Lane",
      :city => "Some Town",
      :province => "BC"
    )
    addr.should == nil
  end
end