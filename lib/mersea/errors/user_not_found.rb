module Mersea
  module Errors
    class UserNotFound < MerseaError
      def initialize(error)
        @status = 401
        @status_text = 'Unauthorized'
        @errors = [
          {
            code: 'MERSEA-401-000',
            type: 'user',
            metadata: {
              reason: "User with id #{error.id} no longer exists, the provided token is not valid",
              resource: error.model,
              resource_id: error.id
            }
          }
        ]
      end
    end
  end
end
