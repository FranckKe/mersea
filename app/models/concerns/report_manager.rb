module Concerns
  module ReportManager
    extend ActiveSupport::Concern

    included do
      state_machine :status, initial: :pending do
        state :pending
        state :accepted
        state :rejected

        event :accept do
          transition accepted: same, pending: :accepted
        end

        event :reject do
          transition pending: :rejected
        end
      end
    end
  end
end
