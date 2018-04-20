module Mersea
  module Errors
    class Validation < MerseaError
      def initialize(error)
        @status = 422
        @status_text = 'Unprocessable Entity'
        @errors = [
          {
            code: 'MERSEA-422-000',
            type: 'validation',
            metadata: {
              fields: fields_from_details(error.details),
              reason: error.full_messages.join('. '),
              resource: error.instance_variable_get(:@base).class.name
            }
          }
        ]
      end

      private

      def fields_from_details(details)
        [].tap do |fields|
          details.each do |k, v|
            fields << {
              name: k,
              type: v.map { |elt| elt[:error] }
            }
          end
        end
      end
    end
  end
end
