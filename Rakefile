require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

require 'lib/address_standardization/version'

task :default => :test

spec = Gem::Specification.new do |s|
  s.name             = 'address_standardization'
  s.version          = AddressStandardization::Version.to_s
  s.has_rdoc         = true
  s.extra_rdoc_files = %w(README.rdoc)
  s.rdoc_options     = %w(--main README.rdoc)
  s.summary          = "A tiny Ruby library to quickly standardize a postal address"
  s.author           = 'Elliot Winkler'
  s.email            = 'elliot.winkler@gmail.com'
  s.homepage         = 'http://github.com/mcmire/address_standardization'
  s.files            = %w(README.rdoc Rakefile) + Dir.glob("{lib,test}/**/*")
  # s.executables    = ['address_standardization']
  
  s.add_dependency('mechanize')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

desc 'Generate the gemspec to serve this Gem from Github'
task :github do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end

desc "Validates your gemspec like Github does"
task :validate_gemspec do
  require 'yaml'

  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  data = File.read(file)
  spec = nil

  if data !~ %r{!ruby/object:Gem::Specification}
    Thread.new { spec = eval("$SAFE = 3\n#{data}") }.join
  else
    spec = YAML.load(data)
  end

  spec.validate

  puts spec
  puts "OK"
end