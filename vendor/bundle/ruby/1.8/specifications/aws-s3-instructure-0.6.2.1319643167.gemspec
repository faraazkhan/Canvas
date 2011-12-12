# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "aws-s3-instructure"
  s.version = "0.6.2.1319643167"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jacob Fugal"]
  s.date = "2011-10-26"
  s.description = "Client library for Amazon's Simple Storage Service's REST API, forked by Instructure pending action on pull request https://github.com/marcel/aws-s3/pull/40"
  s.email = "jacob@instructure.com"
  s.executables = ["s3sh"]
  s.extra_rdoc_files = ["README", "COPYING", "INSTALL"]
  s.files = ["bin/s3sh", "README", "COPYING", "INSTALL"]
  s.homepage = "http://amazon.rubyforge.org"
  s.rdoc_options = ["--title", "AWS::S3 -- Support for Amazon S3's REST api", "--main", "README", "--line-numbers", "--inline-source"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Client library for Amazon's Simple Storage Service's REST API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<xml-simple>, [">= 0"])
      s.add_runtime_dependency(%q<builder>, [">= 0"])
      s.add_runtime_dependency(%q<mime-types>, [">= 0"])
    else
      s.add_dependency(%q<xml-simple>, [">= 0"])
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<mime-types>, [">= 0"])
    end
  else
    s.add_dependency(%q<xml-simple>, [">= 0"])
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<mime-types>, [">= 0"])
  end
end
