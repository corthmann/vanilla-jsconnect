require File.expand_path('../lib/vanilla-jsconnect/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'vanilla-jsconnect'
  s.version     = VanillaJsConnect::VERSION.dup
  s.date        = '2015-01-17'
  s.summary     = ""
  s.description = ""
  s.authors     = ["Christian Orthmann"]
  s.email       = 'christian.orthmann@gmail.com'
  s.require_path = 'lib'
  s.files       = `git ls-files`.split("\n") - %w(.rvmrc .gitignore)
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n") - %w(.rvmrc .gitignore)
  s.homepage    = 'http://rubygems.org/gems/vanilla-jsconnect'
  s.license     = 'MIT'

  s.add_development_dependency('rake', '~> 10')
  s.add_development_dependency('rspec', '~> 3')
  s.add_development_dependency('simplecov', '~> 0')
  s.add_development_dependency('simplecov-rcov', '~> 0')
  s.add_development_dependency('yard', '~> 0')
end