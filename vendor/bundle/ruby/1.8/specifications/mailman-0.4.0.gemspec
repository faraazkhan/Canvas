# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mailman"
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jonathan Rudenberg"]
  s.date = "2010-10-03"
  s.description = "Mailman makes it easy to process incoming emails with a simple routing DSL"
  s.email = ["jonathan@titanous.com"]
  s.homepage = "http://mailmanrb.com"
  s.require_paths = ["lib"]
  s.rubyforge_project = "mailman"
  s.rubygems_version = "1.8.10"
  s.summary = "A incoming email processing microframework"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mail>, [">= 2.0.3"])
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.4"])
      s.add_runtime_dependency(%q<fssm>, [">= 0.1.4"])
      s.add_runtime_dependency(%q<maildir>, [">= 0.5.0"])
      s.add_runtime_dependency(%q<i18n>, [">= 0.4.1"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<mail>, [">= 2.0.3"])
      s.add_dependency(%q<activesupport>, [">= 2.3.4"])
      s.add_dependency(%q<fssm>, [">= 0.1.4"])
      s.add_dependency(%q<maildir>, [">= 0.5.0"])
      s.add_dependency(%q<i18n>, [">= 0.4.1"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<mail>, [">= 2.0.3"])
    s.add_dependency(%q<activesupport>, [">= 2.3.4"])
    s.add_dependency(%q<fssm>, [">= 0.1.4"])
    s.add_dependency(%q<maildir>, [">= 0.5.0"])
    s.add_dependency(%q<i18n>, [">= 0.4.1"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
