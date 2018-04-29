class TracerSerializer < ActiveModel::Serializer
  attributes :id, :name, :color, :photo, :photo_url

  def photo
    variant = object.photo.variant(resize: '256x256>').processed
    Rails.application.routes.url_helpers.rails_blob_representation_path(
      variant.blob.signed_id, variant.variation.key, variant.blob.filename, only_path: true
    )
  end

  def photo_url
    object.photo.url
  end
end
