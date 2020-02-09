# frozen_string_literal: true

require 'http'

# Following env variables needs to be set:
# DATAGOUV_MERSEA_HOST
# DATAGOUV_HOST
# DATAGOUV_API_KEY
# DATAGOUV_DATASET_ID
# DATAGOUV_REPORTS_JSON_ID
# DATAGOUV_REPORTS_GEOJSON_ID
# DATAGOUV_REPORTS_CSV_ID
# DATAGOUV_TRACERS_JSON_ID
# DATAGOUV_TRACERS_CSV_ID

desc 'Upload tracers and reports to datagouv'
task datagouv: :environment do
  tracer_attr = %i[
    id
    name
    description
    origin
    kind
    longitude
    latitude
    created_at
    color
    category
  ]

  @tracers = Tracer.select(tracer_attr)
  # @tracers.map do |tracer|
  #   tracer.photo = "#{ENV['DATAGOUV_MERSEA_HOST']}#{tracer.photo}"
  # end

  puts "#{@tracers.size} tracers found."

  tracers_csv = CSV.generate do |csv|
    csv << @tracers.attribute_names
    @tracers.each do |tracer|
      csv << tracer.attributes.values
    end
  end

  File.open('./tracers.csv', 'w+') do |f|
    f.write(tracers_csv)
  end

  puts 'tracers.csv created.'

  File.open('./tracers.json', 'w+') do |f|
    f.write(@tracers.to_json)
  end

  puts 'tracers.json created.'

  report_attr = %i[
    id
    tracer_id
    name
    quantity
    address
    longitude
    latitude
    description
    reported_at
    created_at
    shore_length
  ]

  @reports = Report.where(status: 'accepted').select(report_attr)

  puts "#{@reports.size} accepted reports found."

  reports_csv = CSV.generate do |csv|
    csv << @reports.attribute_names
    @reports.each do |report|
      csv << report.attributes.values
    end
  end

  File.open('./reports.csv', 'w+') do |f|
    f.write(reports_csv)
  end

  puts 'reports.csv created.'

  File.open('./reports.json', 'w+') do |f|
    f.write(@reports.to_json)
  end

  puts 'reports.json created.'

  File.open('./reports.geojson', 'w+') do |f|
    f.write(GeojsonReportsSerializer.new(@reports).to_json)
  end

  puts 'reports.geojson created.'

  datagouv_dataset_url = "#{ENV['DATAGOUV_HOST']}/datasets/#{ENV['DATAGOUV_DATASET_ID']}/resources"

  tracer_csv_res = HTTP
                   .headers(accept: 'application/json')
                   .headers('Content-Type': 'application/json')
                   .headers('x-api-key': ENV['DATAGOUV_API_KEY'])
                   .post("#{datagouv_dataset_url}/#{ENV['DATAGOUV_TRACERS_CSV_ID']}/upload/",
                         form: {
                           file: HTTP::FormData::File.new('/home/franck/workspace/mersea/tracers.csv')
                         })

  puts tracer_csv_res
end
