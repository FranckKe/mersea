class ImageValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.attached?
    return if value.blob.content_type.start_with?('image/')
    value.purge # Synchronously destroy the image
    record.errors.add(attribute, 'needs to be an image')
  end
end
