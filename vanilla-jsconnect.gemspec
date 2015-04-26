require File.expand_path('../lib/vanilla-jsconnect/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'vanilla-jsconnect'
  s.version     = VanillaJsConnect::VERSION.dup
  s.date        = '2015-04-26'
  s.summary     = "Ruby client library for Vanilla forums to connect websites with SSO through JsConnect."
  s.description = "Ruby client library for Vanilla forums to connect websites with Single Sign On (SSO) through JsConnect."
  s.authors     = ["Christian Orthmann"]
  s.email       = 'christian.orthmann@gmail.com'
  s.require_path = 'lib'
  s.files       = `git ls-files`.split("\n") - %w(.rvmrc .gitignore)
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n") - %w(.rvmrc .gitignore)
  s.homepage    = 'http://rubygems.org/gems/vanilla-jsconnect'
  s.license     = 'GPL-2'

  s.add_development_dependency('rake', '~> 10')
  s.add_development_dependency('rspec', '~> 3')
  s.add_development_dependency('simplecov', '~> 0')
  s.add_development_dependency('simplecov-rcov', '~> 0')
  s.add_development_dependency('yard', '~> 0')
end