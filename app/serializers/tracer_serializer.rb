class TracerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :color, :photo

  def photo
    rails_blob_path(
      object.photo, # object.photo.variant(resize: '100x100>').processed
      disposition: 'attachment',
      only_path: true)
  end
end
