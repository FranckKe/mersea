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
          field :name do
            column_width 66
          end
          field :description do
            column_width 66
          end
          field :photo, :active_storage do
            column_width 50
          end
          field :origin do
            column_width 50
          end
          field :kind do
            column_width 50
          end
          field :category do
            column_width 50
          end
          field :longitude do
            column_width 50
          end
          field :latitude do
            column_width 50
          end
          field :created_at do
            column_width 50
          end
          field :updated_at do
            column_width 50
          end
          field :color, :color do
            column_width 50
          end
        end

        show do
          field :name
          field :description
          field :photo, :active_storage
          field :origin
          field :kind
          field :category
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
          field :category, :enum do
            enum do
              Tracer::CATEGORIES.map do |category|
                [I18n.t(category, scope: 'tracers.categories', translation: I18n.locale), category]
              end
            end
          end
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
