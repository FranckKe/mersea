module Concerns
  module ReportManager
    extend ActiveSupport::Concern

    included do
      state_machine :status, initial: :pending do
        state :pending
        state :accepted
        state :rejected

        after_transition any => :accepted do |report, _|
          report.photo = nil
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
          field :status, :state
          field :tracer
          field :name
          field :email
          field :quantity
          field :longitude
          field :latitude
          field :address
          field :description
          field :reported_at
          field :photo
        end

        edit do
          field :status, :state
          field :tracer
          field :name
          field :email
          field :quantity
          field :longitude
          field :latitude
          field :address
          field :description
          field :reported_at
          field :photo
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
