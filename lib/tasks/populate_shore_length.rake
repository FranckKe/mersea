namespace :db do
  desc 'Populate shore length'
  task populate_shore_length: :environment do
    for report in Report.all
      if report.shore_length.nil?
        report.update_attributes!(shore_length: 1)
        puts "Updated report #{report.id} with shore_length of 1"
      else
        puts 'Nothing to do on this report'
      end
    end
  end
end