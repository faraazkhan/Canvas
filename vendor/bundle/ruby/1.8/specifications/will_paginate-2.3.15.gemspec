# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "will_paginate"
  s.version = "2.3.15"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mislav Marohni\304\207", "PJ Hyett"]
  s.date = "2010-09-08"
  s.description = "The will_paginate library provides a simple, yet powerful and extensible API for ActiveRecord pagination and rendering of pagination links in ActionView templates."
  s.email = "mislav.marohnic@gmail.com"
  s.extra_rdoc_files = ["README.rdoc", "LICENSE", "CHANGELOG.rdoc"]
  s.files = ["README.rdoc", "LICENSE", "CHANGELOG.rdoc"]
  s.homepage = "http://github.com/mislav/will_paginate/wikis"
  s.rdoc_options = ["--main", "README.rdoc", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Pagination for Rails"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
