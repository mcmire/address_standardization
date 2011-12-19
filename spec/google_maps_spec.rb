require File.expand_path('../spec_helper', __FILE__)

AddressStandardization::GoogleMaps.api_key = "ABQIAAAALHg3jKnK9wN9K3_ArJA6TxSTZ2OgdK08l2h0_gdsozNQ-6zpaxQvIY84J7Mh1fAHQrYGI4W27qKZaw"

describe AddressStandardization::GoogleMaps do
  context 'in production mode' do
    before do
      AddressStandardization.test_mode = nil
    end

    it "returns the correct data for a valid US address" do
      addr = AddressStandardization::GoogleMaps.standardize_address(
        # test that it works regardless of symbols or strings
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

    it "returns the correct data for a valid Canadian address" do
      addr = AddressStandardization::GoogleMaps.standardize_address(
        # test that it works regardless of symbols or strings
        :street => "55 East Cordova St. Apt 415",
        :city => "Vancouver",
        "province" => "BC"
      )
      addr.should == AddressStandardization::Address.new(
        "street" => "55 CORDOVA ST E #415",
        "city" => "VANCOUVER",
        "state" => "BC",
        "province" => "BC",
        "postalcode" => "V6A",
        "zip" => "V6A",
        "country" => "CANADA"
      )
    end

    it "returns nothing for an invalid address" do
      addr = AddressStandardization::GoogleMaps.standardize_address(
        :street => "123 Imaginary Lane",
        :city => "Some Town",
        :state => "AK"
      )
      addr.should be_nil
    end
  end

  context 'in test mode' do
    before do
      AddressStandardization.test_mode = true
    end

    it "returns the correct data for a successful response" do
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

      # block form
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

    it "returns nothing for an unsuccessful response" do
      AddressStandardization::GoogleMaps.canned_response = :failure
      addr = AddressStandardization::GoogleMaps.standardize_address(
        :street => "123 Imaginary Lane",
        :city => "Some Town",
        :state => "AK"
      )
      addr.should be_nil
      AddressStandardization::GoogleMaps.canned_response = nil

      # block form
      AddressStandardization::GoogleMaps.with_canned_response(:failure) do
        addr = AddressStandardization::GoogleMaps.standardize_address(
          :street => "123 Imaginary Lane",
          :city => "Some Town",
          :state => "AK"
        )
        addr.should be_nil
      end
    end
  end
end
