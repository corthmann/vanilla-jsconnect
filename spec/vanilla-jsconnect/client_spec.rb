require 'spec_helper'
require 'vanilla-jsconnect/client'
require 'support/vanilla-jsconnect_factory'

module VanillaJsConnect
  describe VanillaJsConnect::Client do

    before do
      VanillaJsConnect.configure do |config|
        config.client_id = VanillaJsConnectFactory.client_id
        config.secret = VanillaJsConnectFactory.secret
      end
    end

    context 'when initialized' do
      context 'without instance configuration' do
        it 'uses the correct configuration' do
          instance = described_class.new
          expect(instance.client_id).to eql(1234567890)
          expect(instance.secret).to eql('nobodyknows')
        end
      end

      context 'with instance configuration' do
        it 'uses the correct configuration' do
          instance = described_class.new({ client_id: 9876543210, secret: 'somethingelse' })
          expect(instance.client_id).to eql(9876543210)
          expect(instance.secret).to eql('somethingelse')
        end
      end
    end

    describe '.authenticate' do
      let(:instance) { described_class.new }

      context 'given a valid request' do
        it 'should return a signed jsconnect response' do
          timestamp = Time.now.to_i
          request = {
              'client_id' => VanillaJsConnectFactory.client_id,
              'timestamp' => timestamp,
              'signature' => instance.send(:generate_signature, timestamp )
          }
          expect(instance.authenticate(request, VanillaJsConnectFactory.user)).to be
        end
      end
    end
  end
end