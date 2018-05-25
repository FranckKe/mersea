module Concerns
  module ReportManager
    extend ActiveSupport::Concern

    included do
      # The following is needed to support deletion
      attribute :remove_photo, :boolean
      after_save -> { photo.purge }, if: :remove_photo

      state_machine :status, initial: :pending do
        state :pending
        state :accepted
        state :rejected

        after_transition any => :accepted do |report, _|
          report.photo.purge
          report.save!
        end

        event :accept do
          transition accepted: same, pending: :accepted
        end

        event :reject do
          transition pending: :rejected
        end
      end

      rails_admin do
        list do
          sort_by :reported_at
          field :status, :state
          field :tracer
          field :name
          field :quantity
          field :address
          field :description
          field :reported_at do
            sort_reverse true
          end
          field :photo
        end

        show do
          include_all_fields
          exclude_fields :latitude, :status
          field :address
          field :description
          field :status, :state
          field :longitude do
            pretty_value do
              bindings[:view].tag(:div, { id: 'map', class: 'map', 'data-lng': bindings[:object].longitude, 'data-lat': bindings[:object].latitude })
            end
          end
        end

        edit do
          field :status, :state
          field :tracer
          field :name
          field :quantity
          field :longitude
          field :latitude
          field :address
          field :description
          field :reported_at
          field :photo, :active_storage
        end

        state(
          events: { reject: 'btn-danger', accept: 'btn-success' },
          states: { rejected: 'label-important', accepted: 'label-success' },
          disable: []
        )
      end
    end
  end
end
