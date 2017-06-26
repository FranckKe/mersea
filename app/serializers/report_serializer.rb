class ReportSerializer < ActiveModel::Serializer
  attributes :name, :latitude, :longitude, :tracer, :reported_at, :tracer_id

  def name
    object.user&.name || object.name
  end

  def tracer
    object.tracer.name
  end
end
