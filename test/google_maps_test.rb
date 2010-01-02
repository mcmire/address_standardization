require 'test_helper'

AddressStandardization::GoogleMaps.api_key = "ABQIAAAALHg3jKnK9wN9K3_ArJA6TxSTZ2OgdK08l2h0_gdsozNQ-6zpaxQvIY84J7Mh1fAHQrYGI4W27qKZaw"

class GoogleMapsTest < Test::Unit::TestCase
  test "A valid US address" do
    addr = AddressStandardization::GoogleMaps::Address.standardize(
      :street => "1600 Amphitheatre Parkway",
      :city => "Mountain View",
      :state => "CA"
    )
    addr.should == AddressStandardization::GoogleMaps::Address.new(
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
    addr = AddressStandardization::GoogleMaps::Address.standardize(
      :street => "1770 Stenson Boulevard",
      :city => "Peterborough",
      :province => "ON"
    )
    addr.should == AddressStandardization::GoogleMaps::Address.new(
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
    addr = AddressStandardization::GoogleMaps::Address.standardize(
      :street => "123 Imaginary Lane",
      :city => "Some Town",
      :state => "AK"
    )
    addr.should == nil
  end
end