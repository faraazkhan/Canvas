# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "hashery"
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Thomas Sawyer", "Kirk Haines", "Robert Klemme", "Jan Molic", "George Moschovitis", "Jeena Paradies", "Erik Veenstra"]
  s.date = "2010-10-10"
  s.description = "The Hashery is a collection of Hash-like classes, spun-off from the original Ruby Facets library. Included are the widely used OrderedHash, the related but more featured Dictionary class, a number of open classes, similiar to the standard OpenStruct and a few variations on the standard Hash."
  s.email = "transfire@gmail.com"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc"]
  s.homepage = "http://rubyworks.github.com/hashery"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--title", "Hashery API", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "hashery"
  s.rubygems_version = "1.8.10"
  s.summary = "Facets bread collection of Hash-like classes."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
