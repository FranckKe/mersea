class GeojsonReportsSerializer < ActiveModel::Serializer
  attributes :type, :features

  def type
    'FeatureCollection'
  end

  def features
    ActiveModelSerializers::SerializableResource.new(object, each_serializer: GeojsonReportSerializer)
  end
end
