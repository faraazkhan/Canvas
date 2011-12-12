# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ruby-saml-mod"
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["OneLogin LLC", "Bracken", "Zach"]
  s.date = "2011-11-05"
  s.description = "This is an early fork from https://github.com/onelogin/ruby-saml - I plan to \"rebase\" these changes ontop of their current version eventually. "
  s.extra_rdoc_files = ["LICENSE"]
  s.files = ["LICENSE"]
  s.homepage = "http://github.com/bracken/ruby-saml"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Ruby library for SAML service providers"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
