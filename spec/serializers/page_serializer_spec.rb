require 'rails_helper'

describe PageSerializer do
  let(:page) { FactoryBot.build(:page) }
  subject { described_class.new(page) }

  it { expect(subject.serializable_hash).to have_key(:id) }
  it { expect(subject.serializable_hash).to have_key(:name) }
  it { expect(subject.serializable_hash).to have_key(:language) }
  it { expect(subject.serializable_hash).to have_key(:content) }
end
