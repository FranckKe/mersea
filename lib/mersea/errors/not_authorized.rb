module Mersea
  module Errors
    class NotAuthorized < MerseaError
      def initialize(error)
        @status = 403
        @status_text = 'Forbidden'
        @errors = if error.record.is_a?(Class)
                    [
                      {
                        code: 'MERSEA-403-000',
                        type: 'action',
                        metadata:
                        {
                          reason: 'You are not authorized to perform this action'
                        }
                      }
                    ]
                  else
                    [
                      {
                        code: 'MERSEA-403-001',
                        type: 'access',
                        metadata:
                          {
                            reason: 'You are not authorized to access this resource',
                            resource: error.record.class.name,
                            resource_id: error.record.id
                          }
                      }
                    ]
                  end
      end
    end
  end
end
