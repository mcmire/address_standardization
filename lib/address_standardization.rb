# address_standardization: A tiny Ruby library to quickly standardize a postal address.
# Copyright (C) 2008-2011 Elliot Winkler. Released under the MIT license.

require 'logging'

# TODO: Force users to require MelissaData or GoogleMaps manually
# so that no dependency is required without being unused
require 'mechanize'
require 'httparty'

here = File.expand_path('..', __FILE__)

require "#{here}/address_standardization/ruby_ext"
require "#{here}/address_standardization/class_level_inheritable_attributes"
require "#{here}/address_standardization/helpers"

require "#{here}/address_standardization/address"
require "#{here}/address_standardization/abstract_service"
require "#{here}/address_standardization/melissa_data"
require "#{here}/address_standardization/google_maps"

module AddressStandardization
  class StandardizationError < StandardError; end

  class << self
    attr_accessor :test_mode
    alias_method :test_mode?, :test_mode

    def logger
      Logging.logger[self]
    end
  end

  self.test_mode = false
  logger.level = ($DEBUG || ENV['DEBUG']) ? :debug : :info
end
