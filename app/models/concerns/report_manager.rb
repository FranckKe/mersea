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

        after_transition any => :rejected do |report, _|
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
          sort_by :created_at
          field :status, :state do
            column_width 50
          end
          field :photo, :active_storage do
            column_width 100
          end
          field :tracer do
            column_width 99
          end
          field :name do
            column_width 99
          end
          field :quantity do
            column_width 50
          end
          field :shore_length do
            column_width 50
          end
          field :description do
            column_width 99
          end
          field :reported_at do
            column_width 99
          end
          field :address do
            column_width 99
          end
          field :created_at do
            column_width 99
            sort_reverse true
          end
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
          field :shore_length
          field :longitude
          field :latitude
          field :address
          field :description
          field :reported_at
          field :photo, :active_storage
        end

        state(
          events: { reject: 'btn-danger', accept: 'btn-success' },
          states: { rejected: 'label-danger', accepted: 'label-success' },
          disable: []
        )
      end
    end
  end
end
