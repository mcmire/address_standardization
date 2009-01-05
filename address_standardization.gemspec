# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{address_standardization}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Elliot Winkler"]
  s.date = %q{2009-01-05}
  s.email = %q{elliot.winkler@gmail.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/address_standardization", "lib/address_standardization/abstract_address.rb", "lib/address_standardization/class_level_inheritable_attributes.rb", "lib/address_standardization/google_maps.rb", "lib/address_standardization/melissa_data.rb", "lib/address_standardization/ruby_ext.rb", "lib/address_standardization/version.rb", "lib/address_standardization.rb", "test/google_maps_test.rb", "test/melissa_data_test.rb", "test/test.xml", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/mcmire/address_standardization}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A tiny Ruby library to quickly standardize a postal address}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mechanize>, [">= 0"])
    else
      s.add_dependency(%q<mechanize>, [">= 0"])
    end
  else
    s.add_dependency(%q<mechanize>, [">= 0"])
  end
end
