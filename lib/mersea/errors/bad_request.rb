module Mersea
  module Errors
    class BadRequest < MerseaError
      def initialize(message)
        @status = 400
        @status_text = 'Bad Request'
        @errors = [
          {
            code: 'MERSEA-400-000',
            type: 'request',
            metadata: {
              reason: message,
            }
          }
        ]
      end
    end
  end
end
