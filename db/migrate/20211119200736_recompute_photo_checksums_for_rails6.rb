class RecomputePhotoChecksumsForRails6 < ActiveRecord::Migration[6.0]
  def change
    Tracer.all.each do |tracer|
      blob = tracer.photo.blob
      blob.update_columns(checksum: Digest::MD5.base64digest(File.read(blob.service.path_for(blob.key))))
    end

    Report.where(status: :pending).each do |report|
      blob = report.photo.blob
      blob.update_columns(checksum: Digest::MD5.base64digest(File.read(blob.service.path_for(blob.key))))
    end
  end
end
