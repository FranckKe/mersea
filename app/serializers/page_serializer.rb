class PageSerializer < ActiveModel::Serializer
  attributes :id, :name, :language, :content, :category
end
