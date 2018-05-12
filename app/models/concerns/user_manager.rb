module Concerns
  module UserManager
    extend ActiveSupport::Concern

    included do
      rails_admin do
        list do
          field :name
          field :email
          field :senior
          field :language
          field :created_at
          field :updated_at
          field :reset_password_sent_at
        end
      end
    end
  end
end
