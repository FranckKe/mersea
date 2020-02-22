namespace :db do
  desc 'Populate shore length'
  task populate_shore_length: :environment do
    production_date = Date.strptime("02-05-2020", "%m-%d-%Y")

    Report.all.each do |report|
      if report.shore_length == 1 && report.created_at < production_date
        report.update_attributes!(shore_length: nil)
      elsif report.shore_length < 1000
        report.update_attributes!(shore_length: report.shore_length * 1000)
        puts "Updated report #{report.id} with shore_length of 1000"
      end
    end
  end
end
