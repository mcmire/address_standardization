# address_standardization

## What is it?

Despite the long name, this is a tiny Ruby library to quickly standardize a
postal address, either via the Google Geocoding API or MelissaData. So if you
have an online store and you need to verify a shipping address, then you might
consider using this library.

## What is it *not*?

This is not a library to *geocode* addresses or locations. In other words, you
won't get world coordinates back for a location. If you need this information,
then there are other libraries that will do this for you, such as
[graticule](http://github.com/collectiveidea/graticule) or
[GeoKit](http://github.com/andre/geokit-gem).

## How do I install it?

    gem install address_standardization

## How do I use it?

Right now this library supports two services: the Google Geocoding API and
MelissaData. All services work the same way: you call a `standardize_address`
method with a hash of address data. If the address exists (according to the
service), you'll get back a full hash of address data. Otherwise, you'll get
back `nil`.

Both Google and MelissaData have benefits and drawbacks. First, in terms of
postal addresses there are three kinds of addresses you are probably concerned
with: US addresses, Canadian addresses, and then international addresses.

### Google

Google is pretty great in that in knows about all sorts of addresses. So if
you're trying to verify an address in France, then Google probably knows about
it. However, it is not very useful in terms of standardizing US addresses,
because it doesn't know what to do with P.O. boxes.

That said, here is how you'd standardize a US address:

    addr = AddressStandardization::GoogleMaps.standardize_address(
      :street => "1600 Amphitheatre Parkway",
      :city => "Mountain View",
      :state => "CA"
    )
    addr.street      #=> "1600 AMPHITHEATRE PKWY"
    addr.city        #=> "MOUNTAIN VIEW"
    addr.county      #=> "SANTA CLARA"
    addr.state       #=> "CA"
    addr.zip         #=> "94043"
    addr.country     #=> "UNITED STATES"

By default, the `standardize_address` method will leave it up to the service to
decide which country to scope the address query to. Google may be able to figure
it out based on the address you provide, but you can always narrow it down by
providing a `:country` key. So for instance, to standardize a Canadian address:

    addr = AddressStandardization::GoogleMaps.standardize_address(
      :street => "55 East Cordova St. Apt 415",
      :city => "Vancouver",
      :province => "BC",
      :country => "Canada"
    )
    addr.street       #=> "55 E CORDOVA ST"
    addr.city         #=> "VANCOUVER"
    addr.district     #=> "GREATER VANCOUVER REGIONAL DISTRICT"
    addr.province     #=> "ON"
    addr.postal_code  #=> "V6A 1K3"
    addr.country      #=> "CANADA"

Note that `province` is an alias for `state`, `district` is an alias for
`county` and `postal_code` is an alias for `zip`.

And to standardize a French address:

    addr = AddressStandardization::GoogleMaps.standardize_address(
      :street => "Parvis de Notre Dame",
      :city => "Paris",
      :country => "France"
    )
    addr.street       #=> "PLACE DU PARVIS NOTRE-DAME"
    addr.city         #=> "PARIS"
    addr.region       #=> "ÎLE-DE-FRANCE"
    addr.postal_code  #=> "75004"
    addr.country      #=> "FRANCE"

Finally, note what happens if we attempt to standardize a bogus address:

    addr = AddressStandardization::GoogleMaps.standardize_address(
      :street => "abcdef"
    )
    addr  #=> nil

### MelissaData

If you want to simply verify US addresses, then MelissaData is a better bet, as
it not only understands P.O. boxes, but it is also able to tell whether a unit
or apartment number is left out of the address (although currently this
information is not used; there is an
[open ticket](https://github.com/mcmire/address_standardization/issues/12) to
do this).

Standardizing a US address works much the same way as with Google:

    addr = AddressStandardization::MelissaData.standardize_address(
      :street => "1600 Amphitheatre Parkway",
      :city => "Mountain View",
      :state => "CA"
    )
    addr.street      #=> "1600 AMPHITHEATRE PKWY"
    addr.city        #=> "MOUNTAIN VIEW"
    addr.county      #=> "SANTA CLARA"
    addr.state       #=> "CA"
    addr.zip         #=> "94043-1351"
    addr.country     #=> "UNITED STATES"

As mentioned, you can also do P.O. boxes:

    addr = AddressStandardization::MelissaData.standardize_address(
      :street => 'P.O. Box 400160',
      :city => 'Charlottesville',
      :state => 'VA'
    )
    addr.street      #=> "PO BOX 400160"
    addr.city        #=> "CHARLOTTESVILLE"
    addr.county      #=> "ALBEMARLE"
    addr.state       #=> "VA"
    addr.zip         #=> "22904-4160"
    addr.country     #=> "UNITED STATES"

## How do I hack on it?

* Run `bundle install` to ensure you have all dependencies.
* Add your changes.
* Write some tests! Tests are written in RSpec, so `rspec FILE` to run a
  single test, and `rake test` to run all of the tests.
* If you're feeling generous, fork the project and submit a pull request. I'll
  take a look at it when I can.

## Contributors

* Evan Whalen ([evanwhalen](http://github.com/evanwhalen))
* Ryan Heneise ([mysmallidea](http://github.com/mysmallidea))

## Support

If you need help, you can get in touch with me here on Github, or via:

  * **Twitter**: [@mcmire](http://twitter.com/mcmire)
  * **Email**: <elliot.winkler@gmail.com>

## Copyright/License

(c) 2008-2011 Elliot Winkler. All code in this project is free to use, modify,
and redistribute for any purpose, commercial or personal. An attribution, while
not required, would be appreciated.
