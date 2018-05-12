require 'rails_helper'

describe TracerSerializer do
  let(:tracer) { FactoryBot.build(:tracer) }
  subject { described_class.new(tracer) }

  it { expect(subject.serializable_hash).to have_key(:id) }
  it { expect(subject.serializable_hash).to have_key(:name) }
  it { expect(subject.serializable_hash).to have_key(:color) }
end
