module Concerns
  module PageManager
    extend ActiveSupport::Concern

    included do
      rails_admin do
        list do
          field :id
          field :name
          field :content
        end

        edit do
          field :name
          field :content, :froala
        end
      end
    end
  end
end
