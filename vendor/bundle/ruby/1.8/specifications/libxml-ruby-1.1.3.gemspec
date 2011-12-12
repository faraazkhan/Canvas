# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "libxml-ruby"
  s.version = "1.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Charlie Savage"]
  s.date = "2009-03-21"
  s.description = "The Libxml-Ruby project provides Ruby language bindings for the GNOME Libxml2 XML toolkit. It is free software, released under the MIT License. Libxml-ruby's primary advantage over REXML is performance - if speed  is your need, these are good libraries to consider, as demonstrated by the informal benchmark below."
  s.email = "libxml-devel@rubyforge.org"
  s.extensions = ["ext/libxml/extconf.rb"]
  s.files = ["ext/libxml/extconf.rb"]
  s.homepage = "http://libxml.rubyforge.org/"
  s.require_paths = ["lib", "ext/libxml"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.4")
  s.rubyforge_project = "libxml"
  s.rubygems_version = "1.8.10"
  s.summary = "Ruby libxml bindings"

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
