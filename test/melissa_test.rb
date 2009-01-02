require 'test_helper'

class MelissaTest < Test::Unit::TestCase
  test "USA address" do
    addr = AddressStandardization::Melissa::USAddress.standardize(
      :street => "1000 Corporate Centre Dr.",
      :city => "Franklin",
      :state => "TN"
    )
    addr.should == AddressStandardization::Melissa::USAddress.new(
      "street" => "1000 CORPORATE CENTRE DR",
      "city" => "FRANKLIN",
      "state" => "TN",
      "zip" => "37067-2611"
    )
  end
  
  test "Canada address" do
    addr = AddressStandardization::Melissa::CanadianAddress.standardize(
      :street => "103 Metig St",
      :city => "Sault Ste Marie",
      :province => "ON"
    )
    addr.should == AddressStandardization::Melissa::CanadianAddress.new(
      "street" => "103 METIG ST RR 4",
      "province" => "ON",
      "city" => "SAULT STE MARIE",
      "postalcode" => "P6A 5K9"
    )
  end
end