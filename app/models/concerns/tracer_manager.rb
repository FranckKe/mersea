module Concerns
  module TracerManager
    extend ActiveSupport::Concern

    included do
      # The following is needed to support deletion
      attribute :remove_photo, :boolean
      after_save -> { photo.purge }, if: :remove_photo

      rails_admin do
        list do
          sort_by :created_at
          field :name
          field :description
          field :photo, :active_storage
          field :origin
          field :kind
          field :longitude
          field :latitude
          field :created_at
          field :updated_at
          field :color, :color
        end

        show do
          field :name
          field :description
          field :photo, :active_storage
          field :origin
          field :kind
          field :longitude
          field :latitude
          field :color, :color
          field :created_at
          field :updated_at
        end

        edit do
          field :name
          field :description
          field :photo, :active_storage
          field :origin
          field :kind
          field :longitude
          field :latitude
          field :color do
            html_attributes type: 'color'
          end
        end
      end
    end
  end
end
