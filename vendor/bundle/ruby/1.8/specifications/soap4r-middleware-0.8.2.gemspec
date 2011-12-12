# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "soap4r-middleware"
  s.version = "0.8.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Palmer"]
  s.date = "2011-03-10"
  s.description = "Sometimes, you just gotta SOAP."
  s.email = ["brian@codekitchen.net"]
  s.homepage = "https://www.github.com/codekitchen/soap4r-middleware"
  s.require_paths = ["lib"]
  s.rubyforge_project = "soap4r-middleware"
  s.rubygems_version = "1.8.10"
  s.summary = "Provides a Rack middleware for exposing SOAP server endpoints"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<soap4r>, ["~> 1.5"])
    else
      s.add_dependency(%q<soap4r>, ["~> 1.5"])
    end
  else
    s.add_dependency(%q<soap4r>, ["~> 1.5"])
  end
end
