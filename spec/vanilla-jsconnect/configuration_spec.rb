require 'spec_helper'
require 'vanilla-jsconnect/configuration'

module VanillaJsConnect
  describe VanillaJsConnect::Configuration do
    after do
      VanillaJsConnect.reset
    end

    describe '.configure' do
      VanillaJsConnect::Configuration::VALID_OPTIONS_KEYS.each do |key|
        it "should set the #{key}" do
          VanillaJsConnect.configure do |config|
            config.send("#{key}=", key)
            expect(VanillaJsConnect.send(key)).to eql(key)
          end
        end
      end
    end

    VanillaJsConnect::Configuration::VALID_OPTIONS_KEYS.each do |key|
      describe ".#{key}" do
        it 'should reutrn the default value' do
          expect(VanillaJsConnect.send(key)).to eql(VanillaJsConnect::Configuration.const_get("DEFAULT_#{key.upcase}"))
        end
      end
    end
  end
end