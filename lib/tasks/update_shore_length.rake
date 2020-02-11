namespace :db do
  desc 'Update shore length'
  task update_shore_length: :environment do
    production_date = Date.new(2020, 02, 05)

    Report.all.each do |report|
      next unless report.shore_length
      if report.shore_length == 1 && report.created_at < production_date
        report.update_attribute(:shore_length, nil)
        puts "Updated report #{report.id} with shore_length of nil"
      elsif report.shore_length < 1000
        report.update_attributes!(shore_length: report.shore_length * 1000)
        puts "Updated report #{report.id} with shore_length of #{report.shore_length}"
      end
    end
  end
end
