class GeojsonReportSerializer < ActiveModel::Serializer
  attributes :type, :properties, :geometry

  def type
    'Feature'
  end

  def properties
    {
      id: object.id,
      reported_at: object.reported_at,
      name: object.user&.name || object.name,
      tracer_id: object.tracer_id,
      title: object.tracer.name,
      icon: object.tracer.color,
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
