require 'rubygems'
require 'rake'

require File.dirname(__FILE__) + "/lib/address_standardization/version.rb"

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.version = AddressStandardization::VERSION
    gem.name = "address_standardization"
    gem.summary = %Q{A tiny Ruby library to quickly standardize a postal address}
    gem.description = %Q{A tiny Ruby library to quickly standardize a postal address}
    gem.authors = ["Elliot Winkler"]
    gem.email = "elliot.winkler@gmail.com"
    gem.homepage = "http://github.com/mcmire/address_standardization"
    gem.add_dependency "mechanize"
    gem.add_development_dependency "jeremymcanally-context"
    gem.add_development_dependency "mcmire-matchy"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "address_standardization #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end