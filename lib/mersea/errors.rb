module Mersea
  module Errors
    class MerseaError < StandardError
      include ActiveModel::Serialization

      attr_reader :status, :status_text, :errors
    end

    module_function

    # rubocop:disable Metrics/CyclomaticComplexity
    def format(error)
      case error
      when ActiveModel::Errors
        Validation.new(error)
      when Pundit::NotAuthorizedError
        NotAuthorized.new(error)
      when ActiveRecord::RecordNotFound
        if error.model == User.name
          UserNotFound.new(error)
        else
          RecordNotFound.new(error)
        end
      else
        InternalServer.new(error) # TODO
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity
  end
end
