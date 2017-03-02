module Concerns
  module TracerManager
    extend ActiveSupport::Concern

    included do
      rails_admin do
        list do
          sort_by :created_at
          field :name
          field :description
          field :photo
          field :origin
          field :kind
          field :longitude
          field :latitude
          field :created_at
          field :updated_at
          field :color, :color
        end

        edit do
          field :name
          field :description
          field :photo
          field :origin
          field :kind
          field :longitude
          field :latitude
          field :color, :color
        end
      end
    end
  end
end
