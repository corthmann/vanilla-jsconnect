require 'spec_helper'
require 'vanilla-jsconnect/configuration'

module VanillaJsConnect
  describe VanillaJsConnect::Error do
    describe 'when initialized' do
      let(:instance) { described_class.new('some_code', 'some error message') }

      it 'sets the code and message' do
        expect(instance.code).to eql('some_code')
        expect(instance.message).to eql('some error message')
      end

      it 'converts to json correctly' do
        expect(instance.to_json).
            to eql({ code: 'some_code', message: 'some error message'}.to_json)
      end

      context '.inspect' do
        it 'has the correct format' do
          expect(instance.inspect).
              to eql('#<VanillaJsConnect::Error: VanillaJsConnect::Error code="some_code" message="some error message">')
        end
      end
    end
  end
end