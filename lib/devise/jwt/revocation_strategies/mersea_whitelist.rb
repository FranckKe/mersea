module Devise
  module JWT
    module RevocationStrategies
      module MerseaWhitelist
        extend ActiveSupport::Concern

        included do
          has_many :access_tokens, dependent: :destroy

          def self.jwt_revoked?(payload, user)
            !user.access_tokens.exists?(payload.slice('jti', 'aud'))
          end

          def self.revoke_jwt(payload, user)
            user.access_tokens.find_by(payload.slice('jti', 'aud'))&.destroy!
          end
        end

        # Warden::JWTAuth::Interfaces::User#on_jwt_dispatch
        # :reek:FeatureEnvy
        def on_jwt_dispatch(_token, payload)
          access_tokens.create!(
            jti: payload['jti'],
            aud: payload['aud'],
            exp: Time.at(payload['exp'].to_i)
          )
        end
      end
    end
  end
end
