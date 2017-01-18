module Concerns
  module RailsAdmin
    extend ActiveSupport::Concern

    included do
      rails_admin do
        list do
          include_all_fields
          exclude_fields :id, :created_at
        end

        edit do
          include_all_fields
          exclude_fields :id, :created_at
        end
      end
    end
  end
end
