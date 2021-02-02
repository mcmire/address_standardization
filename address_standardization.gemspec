# -*- encoding: utf-8 -*-
require File.expand_path('../lib/address_standardization/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Elliot Winkler']
  gem.email         = ['elliot.winkler@gmail.com']
  gem.description   = "A tiny Ruby library to quickly standardize a postal address"
  gem.summary       = "A tiny Ruby library to quickly standardize a postal address"
  gem.homepage      = 'http://github.com/mcmire/address_standardization'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "address-standardization"
  gem.require_paths = ["lib"]
  gem.version       = AddressStandardization::VERSION

  # 2.0.1 contains a bug, hardcode to 2.0.0 for now until 2.1 comes out
  gem.add_runtime_dependency('mechanize', '2.7.7')
  gem.add_runtime_dependency('httparty', '~> 0.8.1')
  gem.add_runtime_dependency('logging', '~> 1.6.1')

  gem.add_development_dependency('rspec', '~> 2.7.0')
end
