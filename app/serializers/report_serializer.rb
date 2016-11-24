class ReportSerializer < ActiveModel::Serializer
  attributes :latitude, :longitude, :tracer, :reported_at

  def tracer
    object.tracer.name
  end
end
