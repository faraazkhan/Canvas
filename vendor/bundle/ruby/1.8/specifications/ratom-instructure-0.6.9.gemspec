# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ratom-instructure"
  s.version = "0.6.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peerworks", "Sean Geoghegan", "Jacob Fugal"]
  s.date = "2011-07-13"
  s.description = "A fast Atom Syndication and Publication API based on libxml"
  s.email = "seangeo@gmail.com"
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = ["LICENSE", "README.rdoc"]
  s.homepage = "http://github.com/lukfugl/ratom"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Atom Syndication and Publication API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_runtime_dependency(%q<libxml-ruby>, [">= 1.1.2"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<libxml-ruby>, [">= 1.1.2"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<libxml-ruby>, [">= 1.1.2"])
  end
end
