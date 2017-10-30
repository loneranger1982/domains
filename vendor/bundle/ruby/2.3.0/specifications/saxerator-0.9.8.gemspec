# -*- encoding: utf-8 -*-
# stub: saxerator 0.9.8 ruby lib

Gem::Specification.new do |s|
  s.name = "saxerator".freeze
  s.version = "0.9.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Bradley Schaefer".freeze]
  s.date = "2017-02-26"
  s.description = "    Saxerator is a streaming xml-to-hash parser designed for working with very large xml files by\n    giving you Enumerable access to manageable chunks of the document.\n".freeze
  s.email = ["bradley.schaefer@gmail.com".freeze]
  s.homepage = "https://github.com/soulcutter/saxerator".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.1.0".freeze)
  s.rubyforge_project = "saxerator".freeze
  s.rubygems_version = "2.6.11".freeze
  s.summary = "A SAX-based XML-to-hash parser for parsing large files into manageable chunks".freeze

  s.installed_by_version = "2.6.11" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<nokogiri>.freeze, [">= 1.4.0"])
      s.add_development_dependency(%q<ox>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.1"])
    else
      s.add_dependency(%q<nokogiri>.freeze, [">= 1.4.0"])
      s.add_dependency(%q<ox>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.1"])
    end
  else
    s.add_dependency(%q<nokogiri>.freeze, [">= 1.4.0"])
    s.add_dependency(%q<ox>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.1"])
  end
end
