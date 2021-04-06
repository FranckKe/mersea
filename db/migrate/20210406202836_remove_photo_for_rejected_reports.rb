class RemovePhotoForRejectedReports < ActiveRecord::Migration[6.0]
  def change
    Report.where(status: :rejected).each do |report|
      report.photo.purge
      report.save!
    end
  end
end
