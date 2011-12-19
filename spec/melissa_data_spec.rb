require File.expand_path('../spec_helper', __FILE__)

describe AddressStandardization::MelissaData do
  context 'in production mode' do
    before do
      AddressStandardization.test_mode = nil
    end

    it "returns the correct data for a valid US address (with implicit country)" do
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

    it "returns the correct data for a valid US address (with explicit country)" do
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

    it "returns nothing for an invalid US address" do
      addr = AddressStandardization::MelissaData.standardize_address(
        :street => "123 Imaginary Lane",
        :city => "Some Town",
        :state => "AK"
      )
      addr.should == nil
    end

    it "returns the correct data for a valid Canadian address" do
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

    it "returns nothing for an invalid Canadian address" do
      addr = AddressStandardization::MelissaData.standardize_address(
        :street => "123 Imaginary Lane",
        :city => "Some Town",
        :province => "BC"
      )
      addr.should be_nil
    end
  end

  context 'in test mode' do
    it "returns the correct data for a valid address" do
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

      # block form
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

    it "returns the correct data for an invalid address" do
      AddressStandardization::MelissaData.canned_response = :failure
      addr = AddressStandardization::MelissaData.standardize_address(
        :street => "123 Imaginary Lane",
        :city => "Some Town",
        :province => "BC"
      )
      addr.should be_nil
      AddressStandardization::MelissaData.canned_response = nil

      # block form
      AddressStandardization::MelissaData.with_canned_response(:failure) do
        addr = AddressStandardization::MelissaData.standardize_address(
          :street => "123 Imaginary Lane",
          :city => "Some Town",
          :province => "BC"
        )
        addr.should be_nil
      end
    end
  end
end
