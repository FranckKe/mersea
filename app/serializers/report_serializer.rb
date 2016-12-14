class ReportSerializer < ActiveModel::Serializer
  attributes :name, :latitude, :longitude, :tracer, :reported_at

  def tracer
    object.tracer.name
  end
end
