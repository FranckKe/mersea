require 'rails_helper'

describe ReportPolicy do
  let(:resource) { FactoryBot.create(:report) }
  let(:user) { UserContext.new(resource.user, {}) }

  subject { described_class.new(user, resource) }

  before do
    allow(subject).to receive(:verify_recaptcha).and_return(false)
  end

  context 'being an anonymous' do
    let(:user) { UserContext.new(nil, {}) }

    it { is_expected.to forbid_action(:create) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'being an anonymous with a captcha' do
    let(:user) { UserContext.new(nil, {}) }

    before do
      allow(subject).to receive(:verify_recaptcha).and_return(true)
    end

    it { is_expected.to permit_action(:create) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'being the owner' do
    it { is_expected.to permit_action(:create) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:destroy) }
  end
end
