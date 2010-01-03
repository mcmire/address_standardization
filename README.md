# address_standardization

## Summary

A tiny Ruby library to quickly standardize a postal address, either through MelissaData or Google Maps.

## Installation

If you are using Rails, put this in your environment.rb:

    config.gem 'address_standardization'

Then run `rake gems:install` to install the gem.

Otherwise, just run

    gem install address_standardization

## Usage

Right now this library supports two services: MelissaData and Google Maps.

MelissaData provides two services itself: [US address lookup](http://www.melissadata.com/lookups/AddressVerify.asp) and [Canadian address lookup](http://www.melissadata.com/lookups/CanadianAddressVerify.asp). They both work the same way, however. First, here's how to standardize a US address:

    addr = AddressStandardization::MelissaData::Address.standardize(
      :street => "1 Infinite Loop",
      :city => "Cupertino",
      :state => "CA"
    )
  
This submits the address to MelissaData. If the address can't be found, you'll get back `nil`. But if the address can be found (as in this case), you'll get an instance of `AddressStandardization::MelissaData::Address`. If you store the instance, you can refer to the individual fields like so:

    addr.street  #=> "1 INFINITE LOOP"
    addr.city    #=> "CUPERTINO"
    addr.state   #=> "CA"
    addr.zip     #=> "95014-2083"
    addr.country #=> "USA"

And standardizing a Canadian address:

    addr = AddressStandardization::MelissaData::Address.standardize(
      :street => "103 Metig St",
      :city => "Sault Ste Marie",
      :province => "ON",
      :country => "Canada"
    )
    addr.street      #=> "103 METIG ST RR 4"
    addr.city        #=> "SAULT STE MARIE"
    addr.province    #=> "ON"
    addr.postalcode  #=> "P6A 5K9"
    addr.country     #=> "CANADA"

Note that when standardizing a Canadian address, the `:country` must be "Canada" (or "CANADA" works too). Otherwise it will be treated as a US address.

Also note that I'm referring to the address's province as `province`, but you can also use `state` if you like. Same goes for the postal code -- you can also refer to it as `zip`.

Using Google Maps to validate an address is just as easy:

    addr = AddressStandardization::GoogleMaps::Address.standardize(
      :street => "1600 Amphitheatre Parkway",
      :city => "Mountain View",
      :state => "CA"
    )
    addr.street     #=> "1600 AMPHITHEATRE PKWY"
    addr.city       #=> "MOUNTAIN VIEW"
    addr.state      #=> "CA"
    addr.zip        #=> "94043"
    addr.country    #=> "USA"
  
And, again, a Canadian address:

    addr = AddressStandardization::GoogleMaps::Address.standardize(
      :street => "1770 Stenson Blvd.",
      :city => "Peterborough",
      :province => "ON"
    )
    addr.street      #=> "1770 STENSON BLVD"
    addr.city        #=> "PETERBOROUGH"
    addr.province    #=> "ON"
    addr.postalcode  #=> "K9K"
    addr.country     #=> "CANADA"

Sharp eyes will notice that the Google Maps API doesn't return the full postal code for Canadian addresses. If you know why this is please let me know (my email address is below).

## Support

If you find any bugs with this plugin, feel free to:

* file a bug report in the [Issues area on Github](http://github.com/mcmire/address_standardization/issues)
* fork the [project on Github](http://github.com/mcmire/address_standardization) and send me a pull request
* email me (*firstname* dot *lastname* at gmail dot com)

## Author/License

(c) 2008 Elliot Winkler. Released under the MIT license.