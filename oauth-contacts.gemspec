# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "oauth/contacts/version"

Gem::Specification.new do |s|
  s.name        = "oauth-contacts"
  s.version     = Oauth::Contacts::VERSION
  s.authors     = ["Joel AZEMAR"]
  s.email       = ["joel.azemar@gmail.com"]
  s.homepage    = "https://github.com/joel/oauth-contacts"
  s.summary     = "Getting mail contacts through OAuth 2.0 for Gmail and Hotmail"

  s.rubyforge_project = "oauth-contacts"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'oauth2'
  s.add_dependency "rails_config"
  s.add_dependency 'multi_json', '~> 1.0.3'
  s.add_development_dependency 'rspec', '~> 2.7'
  # s.add_development_dependency 'webmock'
end