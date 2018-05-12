require 'rails_helper'

describe GeojsonReportsSerializer do
  let(:reports) { [FactoryBot.build(:report)] }
  subject { described_class.new(reports) }

  it { expect(subject.serializable_hash).to have_key(:type) }
  it { expect(subject.serializable_hash).to have_key(:features) }
end
