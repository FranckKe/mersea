class ReportSerializer < ActiveModel::Serializer
  attributes :name, :latitude, :longitude, :tracer, :reported_at, :tracer_id

  def tracer
    object.tracer.name
  end
end
