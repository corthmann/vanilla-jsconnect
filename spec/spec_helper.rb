require 'simplecov'
require 'simplecov-rcov'
require 'codeclimate-test-reporter'

SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter[
                SimpleCov::Formatter::HTMLFormatter,
                SimpleCov::Formatter::RcovFormatter,
                CodeClimate::TestReporter::Formatter
            ]
  add_group('VanillaJsConnect', 'lib/vanilla-jsconnect')
  add_group('Specs', 'spec')
end

require 'vanilla-jsconnect'

require 'rspec'