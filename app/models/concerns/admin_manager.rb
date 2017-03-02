module Concerns
  module AdminManager
    extend ActiveSupport::Concern

    included do
      rails_admin do
        list do
          field :name
          field :email
          field :created_at
          field :updated_at
        end

        edit do
          field :name
          field :email
          field :password
          field :password_confirmation
        end
      end
    end
  end
end
