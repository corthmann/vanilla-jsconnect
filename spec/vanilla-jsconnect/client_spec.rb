require 'spec_helper'
require 'vanilla-jsconnect/client'
require 'support/vanilla-jsconnect_factory'

def generate_valid_request(instance)
  timestamp = Time.now.to_i
  request = {
      'client_id' => VanillaJsConnectFactory.client_id,
      'timestamp' => timestamp,
      'signature' => instance.send(:generate_signature, timestamp )
  }
  request
end

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
      context 'given a valid request' do
        context 'and using SHA1 as hashing method' do
          let(:instance) { described_class.new }

          it 'should return a signed jsconnect response' do
            request = generate_valid_request(instance)
            expect(instance.authenticate(request, VanillaJsConnectFactory.user)).to be
          end
        end

        context 'and using MD5 as hashing method' do
          let(:instance) { described_class.new( { hash_method: :md5 } ) }

          it 'should return a signed jsconnect response' do
            request = generate_valid_request(instance)
            expect(instance.authenticate(request, VanillaJsConnectFactory.user)).to be
          end
        end

        context 'and using an unsupported hashing method' do
          let(:instance) { described_class.new( { hash_method: :sha2 } ) }

          it 'raises a configuration error' do
            request = generate_valid_request(described_class.new)
            expect { instance.authenticate(request, VanillaJsConnectFactory.user) }.
                to raise_error(VanillaJsConnect::Error)
          end
        end
      end

      context 'given an invalid request' do
        context 'which is missing a client id' do
          it 'raises an invalid request error' do
            instance = described_class.new
            request = generate_valid_request(instance)
            request.delete('client_id')
            expect { instance.authenticate(request, VanillaJsConnectFactory.user) }.
                to raise_error(InvalidRequest)
          end
        end

        context 'which contains an invalid client id' do
          it 'raises an invalid client error' do
            instance = described_class.new
            request = generate_valid_request(instance)
            request['client_id'] = 5432167890
            expect { instance.authenticate(request, VanillaJsConnectFactory.user) }.
                to raise_error(InvalidClient)
          end
        end

        context 'which is missing a timestamp' do
          it 'raises an invalid request error' do
            instance = described_class.new
            request = generate_valid_request(instance)
            request.delete('timestamp')
            expect { instance.authenticate(request, VanillaJsConnectFactory.user) }.
                to raise_error(InvalidRequest)
          end
        end

        context 'which contains an invalid timestamp' do
          it 'raises an access denied error' do
            instance = described_class.new
            request = generate_valid_request(instance)
            request['timestamp'] = Time.now - 60*31
            expect { instance.authenticate(request, VanillaJsConnectFactory.user) }.
                to raise_error(InvalidRequest)
          end
        end

        context 'which is missing a signature' do
          it 'raises an invalid request error' do
            instance = described_class.new
            request = generate_valid_request(instance)
            request.delete('signature')
            expect { instance.authenticate(request, VanillaJsConnectFactory.user) }.
                to raise_error(InvalidRequest)
          end
        end

        context 'which contains an invalid signature' do
          it 'raises an access denied error' do
            instance = described_class.new
            request = generate_valid_request(described_class.new( { secret: 'dunno' } ))
            expect { instance.authenticate(request, VanillaJsConnectFactory.user) }.
                to raise_error(AccessDenied)
          end
        end

      end
    end
  end
end