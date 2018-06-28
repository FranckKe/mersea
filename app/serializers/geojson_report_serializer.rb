class GeojsonReportSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :type, :properties, :geometry

  def type
    'Feature'
  end

  def properties
    {
      id: object.id,
      reported_at: object.reported_at,
      user: {
        name:  object.user&.name || object.name
      },
      tracer: {
        id: object.tracer_id,
        name: object.tracer.name,
        photo: photo_url
      },
      color: object.tracer.color,
      quantity: object.quantity
    }
  end

  def geometry
    {
        type: 'Point',
        coordinates: [
          object.longitude,
          object.latitude
        ]
      }
  end

  private

  def photo_url
    variant = object.tracer.photo.variant(resize: '100x100>').processed
    Rails.application.routes.url_helpers.rails_blob_representation_path(
      variant.blob.signed_id, variant.variation.key, variant.blob.filename, only_path: true
    )
  end
end
