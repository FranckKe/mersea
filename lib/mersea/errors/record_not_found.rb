module Mersea
  module Errors
    class RecordNotFound < MerseaError
      def initialize(error)
        @status = 404
        @status_text = 'Not Found'
        @errors = [
          {
            code: 'MERSEA-404-000',
            type: 'record',
            metadata: {
              reason: error.message,
              resource: error.model,
              resource_id: error.id
            }
          }
        ]
      end
    end
  end
end
