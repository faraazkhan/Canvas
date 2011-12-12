# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "yui-compressor"
  s.version = "0.9.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sam Stephenson"]
  s.date = "2011-02-20"
  s.description = "A Ruby interface to YUI Compressor for minifying JavaScript and CSS assets."
  s.email = "sstephenson@gmail.com"
  s.homepage = "http://github.com/sstephenson/ruby-yui-compressor/"
  s.require_paths = ["lib"]
  s.rubyforge_project = "yui"
  s.rubygems_version = "1.8.10"
  s.summary = "JavaScript and CSS minification library"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
