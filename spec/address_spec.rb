require File.expand_path('../spec_helper', __FILE__)

describe AddressStandardization::Address do
  describe '.new' do
    it "raises an ArgumentError if the given hash contains unknown attributes" do
      lambda { described_class.new(:foo => 'bar') }.
        should raise_error(ArgumentError)
    end

    it "doesn't raise an ArgumentError if given nothing" do
      lambda { described_class.new }.should_not raise_error
    end

    it "doesn't raise an ArgumentError if given an empty hash" do
      lambda { described_class.new({}) }.should_not raise_error
    end

    it "doesn't raise an ArgumentError if given a valid hash" do
      lambda { described_class.new(:street => '111 Main St.') }.should_not raise_error
    end

    it "sets the given attributes" do
      addr = described_class.new(
        :street => '111 Main St.',
        :city => 'Boulder',
        :state => 'CO'
      )
      addr.street.should == '111 Main St.'
      addr.city.should == 'Boulder'
      addr.state.should == 'CO'
    end
  end

  it "has a street attribute" do
    subject.street         = 'foo'
    subject.street.should == 'foo'
  end

  it "has a city attribute" do
    subject.city         = 'foo'
    subject.city.should == 'foo'
  end

  it "has a region attribute (aliased to state and province)" do
    subject.region           = 'foo'
    subject.region.should   == 'foo'
    subject.state.should    == 'foo'
    subject.province.should == 'foo'

    subject.state            = 'bar'
    subject.region.should   == 'bar'
    subject.state.should    == 'bar'
    subject.province.should == 'bar'

    subject.province          = 'baz'
    subject.region.should    == 'baz'
    subject.state.should     == 'baz'
    subject.province.should  == 'baz'
  end

  it "has a postal_code attribute (aliased to postcode and zip)" do
    subject.postal_code         = 11111
    subject.postal_code.should == 11111
    subject.postcode.should    == 11111
    subject.zip.should         == 11111

    subject.postal_code         = 22222
    subject.postal_code.should == 22222
    subject.postcode.should    == 22222
    subject.zip.should         == 22222

    subject.postal_code         = 33333
    subject.postal_code.should == 33333
    subject.postcode.should    == 33333
    subject.zip.should         == 33333
  end

  it "has a district attribute (aliased to county)" do
    subject.district         = 'foo'
    subject.district.should == 'foo'
    subject.county.should   == 'foo'

    subject.county           = 'bar'
    subject.district.should == 'bar'
    subject.county.should   == 'bar'
  end

  it "has a country attribute" do
    subject.country         = 'foo'
    subject.country.should == 'foo'
  end

  describe '#attributes' do
    it "returns all of the attributes as a hash" do
      subject.street = '111 Main St.'
      subject.region = 'Georgia'
      subject.country = 'United States'
      subject.attributes.should == {
        :street => '111 Main St.',
        :city => nil,
        :region => 'Georgia',
        :postal_code => nil,
        :district => nil,
        :country => 'United States'
      }
    end
  end

  describe '#==' do
    it "returns false if the given object is not an described_class" do
      subject.should_not == :foo
    end

    it "returns false if the attributes of the given described_class don't match this described_class's attributes" do
      addr1 = described_class.new(
        :street => '111 Pearl St.',
        :city => 'Boulder',
        :state => 'CO'
      )
      addr2 = described_class.new(
        :street => '111 Pearl Pkwy.',
        :city => 'Boulder',
        :state => 'CO'
      )
      addr1.should_not == addr2
    end

    it "returns true otherwise" do
      addr1 = described_class.new(
        :street => '111 Pearl St.',
        :city => 'Boulder',
        :state => 'CO'
      )
      addr2 = described_class.new(
        :street => '111 Pearl St.',
        :city => 'Boulder',
        :state => 'CO'
      )
      addr1.should == addr2
    end
  end
end
