# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ruby-net-ldap"
  s.version = "0.0.4"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Francis Cianfrocca"]
  s.cert_chain = nil
  s.date = "2006-08-15"
  s.description = "Net::LDAP is an LDAP support library written in pure Ruby. It supports all LDAP client features, and a subset of server features as well."
  s.email = "garbagecat10@gmail.com"
  s.extra_rdoc_files = ["README", "ChangeLog", "LICENCE", "COPYING"]
  s.files = ["README", "ChangeLog", "LICENCE", "COPYING"]
  s.homepage = "http://rubyforge.org/projects/net-ldap"
  s.rdoc_options = ["--title", "Net::LDAP", "--main", "README", "--line-numbers"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = "net-ldap"
  s.rubygems_version = "1.8.10"
  s.summary = "A pure Ruby LDAP client library."

  if s.respond_to? :specification_version then
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
