require 'rails_helper'

Mersea::Errors::MerseaError ## Rails fucking autoload..

module Mersea
  module Errors
    describe MerseaError do
      it { expect(subject).to respond_to(:status) }
      it { expect(subject).to respond_to(:status_text) }
      it { expect(subject).to respond_to(:errors) }
    end
  end

  describe Errors do
    describe '.format' do
      context 'when an ActiveModel::Errors is provided' do
        let(:err) { ActiveModel::Errors.new('message') }

        it 'returns a Validation class' do
          expect(described_class.format(err)).to be_an_instance_of(Errors::Validation)
        end
      end

      context 'when a Pundit::NotAuthorizedError is provided' do
        let(:err) { Pundit::NotAuthorizedError.new(record: Class) }

        it 'returns a NotAuthorized class' do
          expect(described_class.format(err)).to be_an_instance_of(Errors::NotAuthorized)
        end
      end

      context 'when an ActiveRecord::RecordNotFound is provided' do
        let(:err) { ActiveRecord::RecordNotFound.new }

        it 'returns a RecordNotFound class' do
          expect(described_class.format(err)).to be_an_instance_of(Errors::RecordNotFound)
        end
      end

      context 'when an ActiveRecord::StatementInvalid is provided' do
        context 'with a PG::InvalidDatetimeFormat' do
          let(:err) { ActiveRecord::StatementInvalid.new('PG::InvalidDatetimeFormat ....') }

          it 'returns a BadRequest class' do
            expect(described_class.format(err)).to be_an_instance_of(Errors::BadRequest)
          end
        end

        context 'with an unknown message' do
          let(:err) { ActiveRecord::StatementInvalid.new('trololo i do not know this one') }

          it 'returns an InternalServer class' do
            expect(described_class.format(err)).to be_an_instance_of(Errors::InternalServer)
          end
        end
      end

      context 'when an unknown error is provided' do
        let(:err) { StandardError.new('message') }

        it 'returns an InternalServer class' do
          expect(described_class.format(err)).to be_an_instance_of(Errors::InternalServer)
        end
      end
    end
  end
end
