require 'rails_helper'

describe GeojsonReportSerializer do
  let(:report) { FactoryBot.build(:report) }
  subject { described_class.new(report) }

  it { expect(subject.serializable_hash).to have_key(:type) }
  it { expect(subject.serializable_hash).to have_key(:properties) }
  it { expect(subject.serializable_hash[:properties]).to have_key(:id) }
  it { expect(subject.serializable_hash[:properties]).to have_key(:reported_at) }
  it { expect(subject.serializable_hash[:properties]).to have_key(:user) }
  it { expect(subject.serializable_hash[:properties][:user]).to have_key(:name) }
  it { expect(subject.serializable_hash[:properties]).to have_key(:tracer) }
  it { expect(subject.serializable_hash[:properties][:tracer]).to have_key(:id) }
  it { expect(subject.serializable_hash[:properties][:tracer]).to have_key(:name) }
  it { expect(subject.serializable_hash[:properties][:tracer]).to have_key(:photo) }
  it { expect(subject.serializable_hash[:properties]).to have_key(:color) }
  it { expect(subject.serializable_hash[:properties]).to have_key(:quantity) }
  it { expect(subject.serializable_hash).to have_key(:geometry) }
  it { expect(subject.serializable_hash[:geometry]).to have_key(:type) }
  it { expect(subject.serializable_hash[:geometry]).to have_key(:coordinates) }
end
