require 'test_helper'

class MelissaDataTest < Test::Unit::TestCase
  test "Valid US address" do
    addr = AddressStandardization::MelissaData::USAddress.standardize(
      :street => "1 Infinite Loop",
      :city => "Cupertino",
      :state => "CA",
      :country => "USA"
    )
    addr.should == AddressStandardization::MelissaData::USAddress.new(
      "street" => "1 INFINITE LOOP",
      "city" => "CUPERTINO",
      "state" => "CA",
      "zip" => "95014-2083",
      "country" => "USA"
    )
  end
  
  test "Invalid US address" do
    addr = AddressStandardization::MelissaData::USAddress.standardize(
      :street => "123 Imaginary Lane",
      :city => "Some Town",
      :state => "AK"
    )
    addr.should == nil
  end
  
  test "Valid Canadian address" do
    addr = AddressStandardization::MelissaData::CanadianAddress.standardize(
      :street => "3025 Clayhill Rd",
      :city => "Mississauga",
      :province => "ON",
      :country => "CANADA"
    )
    addr.should == AddressStandardization::MelissaData::CanadianAddress.new(
      "street" => "3025 CLAYHILL RD",
      "province" => "ON",
      "city" => "MISSISSAUGA",
      "postalcode" => "L5B 4L2",
      "country" => "CANADA"
    )
  end
  
  test "Invalid Canadian address" do
    addr = AddressStandardization::MelissaData::CanadianAddress.standardize(
      :street => "123 Imaginary Lane",
      :city => "Some Town",
      :province => "BC"
    )
    addr.should == nil
  end
end