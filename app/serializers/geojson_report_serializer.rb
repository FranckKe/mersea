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
        photo: rails_blob_path(object.tracer.photo, disposition: 'attachment', only_path: true)
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
end
