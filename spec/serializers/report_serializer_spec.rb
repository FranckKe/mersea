require 'rails_helper'

describe ReportSerializer do
  let(:report) { FactoryBot.build(:report) }
  subject { described_class.new(report) }

  it { expect(subject.serializable_hash).to have_key(:id) }
  it { expect(subject.serializable_hash).to have_key(:name) }
  it { expect(subject.serializable_hash).to have_key(:latitude) }
  it { expect(subject.serializable_hash).to have_key(:longitude) }
  it { expect(subject.serializable_hash).to have_key(:tracer) }
  it { expect(subject.serializable_hash).to have_key(:reported_at) }
  it { expect(subject.serializable_hash).to have_key(:tracer_id) }
  it { expect(subject.serializable_hash).to have_key(:quantity) }
  it { expect(subject.serializable_hash).to have_key(:status) }
end
