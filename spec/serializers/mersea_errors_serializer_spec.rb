require 'rails_helper'

module Mersea::Errors
  describe MerseaErrorSerializer do
    let(:errors) { FactoryBot.build(:mersea_error) }
    subject { described_class.new(errors) }

    it { expect(subject.serializable_hash).to have_key(:status) }
    it { expect(subject.serializable_hash).to have_key(:status_text) }
    it { expect(subject.serializable_hash).to have_key(:errors) }
  end
end
