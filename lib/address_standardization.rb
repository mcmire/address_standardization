# usps_address: Ruby API for tapping into the address validation forms on the USPS
# web site.
#
# Copyright (C) 2008 Elliot Winkler. Licensed under the BSD license.

require 'rubygems'
require 'mechanize'

require File.dirname(__FILE__)+'/address_standardization/ruby_ext'
require File.dirname(__FILE__)+'/address_standardization/class_level_inheritable_attributes'

require File.dirname(__FILE__)+'/address_standardization/abstract_address'
require File.dirname(__FILE__)+'/address_standardization/melissa'