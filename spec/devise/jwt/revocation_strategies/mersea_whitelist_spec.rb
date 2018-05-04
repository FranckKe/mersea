require 'rails_helper'

module Devise::JWT::RevocationStrategies
  describe MerseaWhitelist do
    subject { User } # MerseaWhitelist is included in User and its methods are reachable
    let(:token) { FactoryBot.create(:access_token) }
    let(:user) { token.user }
    let(:payload) { { 'jti' => token.jti, 'exp' => token.exp, 'aud' => token.aud } }

    describe '.jwt_revoked?' do
      context 'when the token is whitelisted' do
        it 'returns false' do
          expect(subject.jwt_revoked?(payload, user)).to eq(false)
        end
      end

      context 'when the token is not whitelisted' do
        it 'returns true' do
          expect(subject.jwt_revoked?(payload.merge('jti' => 'invalid'), user))
            .to eq(true)
        end
      end
    end

    describe '.revoke_jwt' do
      context 'when the token is whitelisted' do
        it 'removes the token' do
          expect_any_instance_of(AccessToken).to receive(:destroy!)

          subject.revoke_jwt(payload, user)
        end
      end

      context 'when the token is not whitelisted' do
        it 'does nothing' do
          expect_any_instance_of(AccessToken).to_not receive(:destroy!)

          subject.revoke_jwt(payload.merge('jti' => 'invalid'), user)
        end
      end
    end
  end
end
