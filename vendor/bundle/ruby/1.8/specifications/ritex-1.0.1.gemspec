# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ritex"
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["William Morgan"]
  s.date = "2010-04-13"
  s.description = "Ritex converts expressions from WebTeX into MathML. WebTeX is an adaptation of \nTeX math syntax for web display. \n\nRitex makes inserting math into HTML pages easy. It supports most TeX\nmath syntax as well as macros.\n"
  s.email = "wmorgan-ritex-gem@masanjin.net"
  s.extra_rdoc_files = ["README", "ReleaseNotes"]
  s.files = ["README", "ReleaseNotes"]
  s.homepage = "http://masanjin.net/ritex/"
  s.require_paths = ["lib"]
  s.requirements = ["none"]
  s.rubyforge_project = "ritex"
  s.rubygems_version = "1.8.10"
  s.summary = "WebTeX to MathML conversion library."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
