class GeojsonReportSerializer < ActiveModel::Serializer
  attributes :type, :properties, :geometry

  def type
    'Feature'
  end

  def properties
    {
      id: object.id,
      reported_at: object.reported_at,
      user_name: object.user&.name || object.name,
      tracer_id: object.tracer_id,
      tracer_name: object.tracer.name,
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
