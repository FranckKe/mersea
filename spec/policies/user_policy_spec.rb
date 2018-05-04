require 'rails_helper'

describe UserPolicy do
  let(:resource) { FactoryBot.create(:user) }
  let(:user) { UserContext.new(resource, {}) }

  subject { described_class.new(user, resource) }

  context 'being an anonymous' do
    let(:user) { UserContext.new(FactoryBot.create(:user), {}) }

    it { is_expected.to forbid_action(:me) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:update_password) }
  end

  context 'being the owner' do
    it { is_expected.to permit_action(:me) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:update_password) }
  end
end
