class ReportSerializer < ActiveModel::Serializer
  attributes :id, :name, :latitude, :longitude, :tracer, :reported_at, :tracer_id,
             :quantity, :shore_length, :status, :address

  def name
    object.user&.name || object.name
  end

  def tracer
    object.tracer.name
  end
end
