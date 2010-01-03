# address_standardization: A tiny Ruby library to quickly standardize a postal address.
# Copyright (C) 2008 Elliot Winkler. Released under the MIT license.

require 'mechanize'

require 'address_standardization/ruby_ext'
require 'address_standardization/class_level_inheritable_attributes'
        
require 'address_standardization/abstract_address'
require 'address_standardization/melissa_data'
require 'address_standardization/google_maps'