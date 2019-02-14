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
        RecordNotFound.new(error)
      when ActiveRecord::StatementInvalid
        case
        when error.message.start_with?('PG::InvalidDatetimeFormat')
          BadRequest.new('Invalid datetime format')
        when error.message.start_with?('PG::DatetimeFieldOverflow')
          BadRequest.new('Invalid datetime value')
        else
          as_internal_server_error(error)
        end
      else
        as_internal_server_error(error)
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def as_internal_server_error(e)
      Rails.logger.error(e.message)
      e.backtrace&.each do |trace|
        Rails.logger.error(trace)
      end
      InternalServer.new(e) # TODO
    end
  end
end
