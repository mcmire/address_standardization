require File.expand_path('../spec_helper', __FILE__)

describe AddressStandardization::MelissaData do
  context 'in production mode' do
    before do
      AddressStandardization.test_mode = nil
    end

    it "returns the correct data for a valid US address" do
      addr = AddressStandardization::MelissaData.standardize_address(
        # test that it works regardless of symbols or strings
        "street" => "1600 Amphitheatre Parkway",
        :city => "Mountain View",
        :state => "CA"
      )
      addr.attributes.should == {
        :street      => "1600 AMPHITHEATRE PKWY",
        :city        => "MOUNTAIN VIEW",
        :district    => "SANTA CLARA",
        :region      => "CA",
        :postal_code => "94043-1351",
        :country     => "UNITED STATES"
      }
    end

    it "returns the correct data for a valid Canadian address" do
      addr = AddressStandardization::MelissaData.standardize_address(
        # test that it works regardless of symbols or strings
        :street => "55 East Cordova St. Apt 415",
        :city => "Vancouver",
        "province" => "BC"
      )
      addr.attributes.should == {
        :street      => "55 E CORDOVA ST",
        :city        => "VANCOUVER",
        :district    => "GREATER VANCOUVER REGIONAL DISTRICT",
        :region      => "BC",
        :postal_code => "V6A 1K3",
        :country     => "CANADA"
      }
    end

    it "returns nothing for an invalid address" do
      addr = AddressStandardization::MelissaData.standardize_address(
        :street => "123 Imaginary Lane",
        :city   => "Some Town",
        :state  => "AK"
      )
      addr.should be_nil
    end
  end

  context 'in test mode' do
    before do
      AddressStandardization.test_mode = true
    end

    it "returns the correct data for a successful response" do
      AddressStandardization::MelissaData.canned_response = :success
      addr = AddressStandardization::MelissaData.standardize_address(
        :street => "123 Imaginary Lane",
        :city => "Some Town",
        :state => "AK"
      )
      addr.attributes.should == {
        :street      => "123 IMAGINARY LANE",
        :city        => "SOME TOWN",
        :district    => nil,
        :region      => "AK",
        :postal_code => nil,
        :country     => nil
      }
      AddressStandardization::MelissaData.canned_response = nil

      # block form
      AddressStandardization::MelissaData.with_canned_response(:success) do
        addr = AddressStandardization::MelissaData.standardize_address(
          :street => "123 Imaginary Lane",
          :city => "Some Town",
          :state => "AK"
        )
        addr.attributes.should == {
          :street      => "123 IMAGINARY LANE",
          :city        => "SOME TOWN",
          :district    => nil,
          :region      => "AK",
          :postal_code => nil,
          :country     => nil
        }
      end
    end

    it "returns nothing for an unsuccessful response" do
      AddressStandardization::MelissaData.canned_response = :failure
      addr = AddressStandardization::MelissaData.standardize_address(
        :street => "123 Imaginary Lane",
        :city => "Some Town",
        :state => "AK"
      )
      addr.should be_nil
      AddressStandardization::MelissaData.canned_response = nil

      # block form
      AddressStandardization::MelissaData.with_canned_response(:failure) do
        addr = AddressStandardization::MelissaData.standardize_address(
          :street => "123 Imaginary Lane",
          :city => "Some Town",
          :state => "AK"
        )
        addr.should be_nil
      end
    end
  end
end
