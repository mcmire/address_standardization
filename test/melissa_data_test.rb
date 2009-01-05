require 'test_helper'

class MelissaDataTest < Test::Unit::TestCase
  test "Valid USA address" do
    addr = AddressStandardization::MelissaData::USAddress.standardize(
      :street => "1 Infinite Loop",
      :city => "Cupertino",
      :state => "CA"
    )
    addr.should == AddressStandardization::MelissaData::USAddress.new(
      "street" => "1 INFINITE LOOP",
      "city" => "CUPERTINO",
      "state" => "CA",
      "zip" => "95014-2083"
    )
  end
  
  test "Invalid USA address" do
    addr = AddressStandardization::MelissaData::USAddress.standardize(
      :street => "123 Imaginary Lane",
      :city => "Some Town",
      :state => "AK"
    )
    addr.should == nil
  end
  
  test "Valid Canadian address" do
    addr = AddressStandardization::MelissaData::CanadianAddress.standardize(
      :street => "103 Metig St",
      :city => "Sault Ste Marie",
      :province => "ON"
    )
    addr.should == AddressStandardization::MelissaData::CanadianAddress.new(
      "street" => "103 METIG ST RR 4",
      "province" => "ON",
      "city" => "SAULT STE MARIE",
      "postalcode" => "P6A 5K9"
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