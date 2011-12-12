# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "guard-coffeescript"
  s.version = "0.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Kessler"]
  s.date = "2011-10-01"
  s.description = "Guard::CoffeeScript automatically generates your JavaScripts from your CoffeeScripts"
  s.email = ["michi@netzpiraten.ch"]
  s.homepage = "http://github.com/netzpirat/guard-coffeescript"
  s.require_paths = ["lib"]
  s.rubyforge_project = "guard-coffeescript"
  s.rubygems_version = "1.8.10"
  s.summary = "Guard gem for CoffeeScript"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<guard>, [">= 0.8.3"])
      s.add_runtime_dependency(%q<coffee-script>, [">= 2.2.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 0.4"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6"])
      s.add_development_dependency(%q<yard>, ["~> 0.7.2"])
      s.add_development_dependency(%q<kramdown>, ["~> 0.13.3"])
    else
      s.add_dependency(%q<guard>, [">= 0.8.3"])
      s.add_dependency(%q<coffee-script>, [">= 2.2.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<guard-rspec>, ["~> 0.4"])
      s.add_dependency(%q<rspec>, ["~> 2.6"])
      s.add_dependency(%q<yard>, ["~> 0.7.2"])
      s.add_dependency(%q<kramdown>, ["~> 0.13.3"])
    end
  else
    s.add_dependency(%q<guard>, [">= 0.8.3"])
    s.add_dependency(%q<coffee-script>, [">= 2.2.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<guard-rspec>, ["~> 0.4"])
    s.add_dependency(%q<rspec>, ["~> 2.6"])
    s.add_dependency(%q<yard>, ["~> 0.7.2"])
    s.add_dependency(%q<kramdown>, ["~> 0.13.3"])
  end
end
