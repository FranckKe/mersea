module Mersea
  module Errors
    class InternalServer < MerseaError
      def initialize(error)
        @status = 500
        @status_text = 'Internal Server Error'
        @errors = [
          {
            code: "MERSEA-500-#{error.class.name}",
            reason: error.message,
            details: error.backtrace.try(:[], 0..4)
          }
        ]
      end
    end
  end
end
