class ReportSerializer < ActiveModel::Serializer
  attributes :id, :name, :latitude, :longitude, :tracer, :reported_at, :tracer_id,
             :quantity

  def name
    object.user&.name || object.name
  end

  def tracer
    object.tracer.name
  end
end
