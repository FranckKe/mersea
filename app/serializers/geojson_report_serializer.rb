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
      tracer_id: object.tracer_id,
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
