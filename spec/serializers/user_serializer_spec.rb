require 'rails_helper'

describe UserSerializer do
  let(:user) { FactoryBot.build(:user) }
  subject { described_class.new(user) }

  it { expect(subject.serializable_hash).to have_key(:id) }
  it { expect(subject.serializable_hash).to have_key(:name) }
  it { expect(subject.serializable_hash).to have_key(:email) }
  it { expect(subject.serializable_hash).to have_key(:senior) }
  it { expect(subject.serializable_hash).to have_key(:language) }
end
