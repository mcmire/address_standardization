# address_standardization: A tiny Ruby library to quickly standardize a postal address
# Copyright (C) 2008 Elliot Winkler. Released under the MIT license.

require 'rubygems'
require 'mechanize'

require File.dirname(__FILE__)+'/address_standardization/ruby_ext'
require File.dirname(__FILE__)+'/address_standardization/class_level_inheritable_attributes'

require File.dirname(__FILE__)+'/address_standardization/abstract_address'
require File.dirname(__FILE__)+'/address_standardization/melissa'