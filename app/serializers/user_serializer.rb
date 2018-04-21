class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :senior, :language
end
