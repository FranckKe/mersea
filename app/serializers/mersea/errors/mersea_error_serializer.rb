module Mersea
  module Errors
    class MerseaErrorSerializer < ActiveModel::Serializer
      attributes :status, :status_text, :errors
    end
  end
end
