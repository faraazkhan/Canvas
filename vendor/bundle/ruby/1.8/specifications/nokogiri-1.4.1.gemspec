# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "nokogiri"
  s.version = "1.4.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aaron Patterson", "Mike Dalessio"]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDNjCCAh6gAwIBAgIBADANBgkqhkiG9w0BAQUFADBBMQ8wDQYDVQQDDAZhYXJv\nbnAxGTAXBgoJkiaJk/IsZAEZFglydWJ5Zm9yZ2UxEzARBgoJkiaJk/IsZAEZFgNv\ncmcwHhcNMDkxMTA1MDAwNDQ4WhcNMTAxMTA1MDAwNDQ4WjBBMQ8wDQYDVQQDDAZh\nYXJvbnAxGTAXBgoJkiaJk/IsZAEZFglydWJ5Zm9yZ2UxEzARBgoJkiaJk/IsZAEZ\nFgNvcmcwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDNSD14Gb2mCX/5\nfE85uW/jT7fcYI8XolrzdpzfvxD3y+Pt/yA5eciBiE+hNAWU2PM1ZMOq4MOV9EqR\nhYzupp/zFoC7ZZ3PF8nJBFKgfKNf0sp9o3XCUviaZjoSYNIvGQocrakQo+h3x3Od\nNqZWtVsLz9P/G1foUBpc95gGGBodbj/CZVc32F+xVvmejqe3RaMLGI70ZOuTcsRi\nt8V4T7okmUbLi6VmPYlH/9mKvU7ObRHXMYNhkkife5phh8vjsiCd8Q397+jFaL0f\nCd23idNV7lbvdjIuYLV+9u5cPkDjANLAnGRaRS1x2SEfH/8g0Te6/jeKfzBH83D0\n5v5HTx+HAgMBAAGjOTA3MAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSwMB0GA1UdDgQW\nBBTs3LnPhoi2m7BTf9tHvNQYsOG7aTANBgkqhkiG9w0BAQUFAAOCAQEAVH7G+nSf\nWMPz7Iwcnd+WrWWq/mr5ke0qQoiz4tk0h7bsa3fEnUDBiMfmQhv/uBzA4Gkw9zxB\nIfKljsZq0yE+du/1u2Mph7dMIg2oiwMurpduPpx9sfaqsqSBBOzggxiUEmHDNrPT\nuTzaid0gdOx/TacZ4RwrEnx6XNkhxC2YaTH2Y68hoJzSzRGtdU2Kk6mT4YraCP+u\nETP5hCJAiB5l4jC8U6wwvKQDHTMoaUu3eu/txe1PDjoe3GICzs/e6bzYBWYmKu7J\n5YM3l5J4rDvIPAGH4VRr5nSs+qbZh+kCdE1khvTxH51xkR3qAfEEogAd2VlnjELM\nf9Gw8x3RwgLvkA==\n-----END CERTIFICATE-----\n"]
  s.date = "2009-12-10"
  s.description = "Nokogiri (\351\213\270) is an HTML, XML, SAX, and Reader parser.  Among Nokogiri's\nmany features is the ability to search documents via XPath or CSS3 selectors.\n\nXML is like violence - if it doesn\342\200\231t solve your problems, you are not using\nenough of it."
  s.email = ["aaronp@rubyforge.org", "mike.dalessio@gmail.com"]
  s.executables = ["nokogiri"]
  s.extensions = ["ext/nokogiri/extconf.rb"]
  s.extra_rdoc_files = ["Manifest.txt", "CHANGELOG.ja.rdoc", "CHANGELOG.rdoc", "README.ja.rdoc", "README.rdoc"]
  s.files = ["bin/nokogiri", "Manifest.txt", "CHANGELOG.ja.rdoc", "CHANGELOG.rdoc", "README.ja.rdoc", "README.rdoc", "ext/nokogiri/extconf.rb"]
  s.homepage = "http://nokogiri.org"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = "nokogiri"
  s.rubygems_version = "1.8.10"
  s.summary = "Nokogiri (\351\213\270) is an HTML, XML, SAX, and Reader parser"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<racc>, [">= 0"])
      s.add_development_dependency(%q<rexical>, [">= 0"])
      s.add_development_dependency(%q<rake-compiler>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<racc>, [">= 0"])
      s.add_dependency(%q<rexical>, [">= 0"])
      s.add_dependency(%q<rake-compiler>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<racc>, [">= 0"])
    s.add_dependency(%q<rexical>, [">= 0"])
    s.add_dependency(%q<rake-compiler>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end
