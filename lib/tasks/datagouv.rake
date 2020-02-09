# frozen_string_literal: true

require 'http'

# See .env.example for env configuration

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
  Rails.application.routes.default_url_options[:host] = ENV['DATAGOUV_MERSEA_HOST']

  puts "#{@tracers.size} tracers found."

  tracers_csv = CSV.generate do |csv|
    # Header
    csv << tracer_attr + ['photo_url']
    # Values
    @tracers.each do |tracer|
      puts [Rails.application.routes.url_helpers.url_for(tracer.photo)]
      csv << tracer.slice(*tracer_attr).values + [Rails.application.routes.url_helpers.url_for(tracer.photo)]
    end
  end

  File.open('./datagouv/tracers.csv', 'w+') do |f|
    f.write(tracers_csv)
  end

  puts 'tracers.csv created.'

  File.open('./datagouv/tracers.json', 'w+') do |f|
    @tracers_with_photo_url = @tracers.map do |tracer|
      tracer.as_json(only: tracer_attr).merge(photo: Rails.application.routes.url_helpers.url_for(tracer.photo))
    end
    f.write(@tracers_with_photo_url.to_json)
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
    csv << report_attr
    @reports.each do |report|
      csv << report.slice(*report_attr).values
    end
  end

  File.open('./datagouv/reports.csv', 'w+') do |f|
    f.write(reports_csv)
  end

  puts 'reports.csv created.'

  File.open('./datagouv/reports.json', 'w+') do |f|
    f.write(@reports.as_json(only: report_attr).to_json)
  end

  puts 'reports.json created.'

  File.open('./datagouv/reports.geojson', 'w+') do |f|
    f.write(GeojsonReportsSerializer.new(@reports).to_json)
  end

  puts 'reports.geojson created.'

  datagouv_dataset_url = "#{ENV['DATAGOUV_HOST']}/datasets/#{ENV['DATAGOUV_DATASET_ID']}/resources"

  puts "datagouv_dataset_url #{datagouv_dataset_url}"

  tracers_csv_res = HTTP
                    .headers(accept: 'application/json')
                    .headers('x-api-key': ENV['DATAGOUV_API_KEY'])
                    .post("#{datagouv_dataset_url}/#{ENV['DATAGOUV_TRACERS_CSV_ID']}/upload/",
                          form: {
                            file: HTTP::FormData::File.new('./datagouv/tracers.csv')
                          })
  puts tracers_csv_res

  tracers_json_res = HTTP
                     .headers(accept: 'application/json')
                     .headers('x-api-key': ENV['DATAGOUV_API_KEY'])
                     .post("#{datagouv_dataset_url}/#{ENV['DATAGOUV_TRACERS_JSON_ID']}/upload/",
                           form: {
                             file: HTTP::FormData::File.new('./tracers.json')
                           })
  puts tracers_json_res

  reports_json_res = HTTP
                     .headers(accept: 'application/json')
                     .headers('x-api-key': ENV['DATAGOUV_API_KEY'])
                     .post("#{datagouv_dataset_url}/#{ENV['DATAGOUV_REPORTS_JSON_ID']}/upload/",
                           form: {
                             file: HTTP::FormData::File.new('./reports.json')
                           })
  puts reports_json_res

  reports_geojson_res = HTTP
                        .headers(accept: 'application/json')
                        .headers('x-api-key': ENV['DATAGOUV_API_KEY'])
                        .post("#{datagouv_dataset_url}/#{ENV['DATAGOUV_REPORTS_GEOJSON_ID']}/upload/",
                              form: {
                                file: HTTP::FormData::File.new('./reports.geojson')
                              })
  puts reports_geojson_res

  reports_csv_res = HTTP
                    .headers(accept: 'application/json')
                    .headers('x-api-key': ENV['DATAGOUV_API_KEY'])
                    .post("#{datagouv_dataset_url}/#{ENV['DATAGOUV_REPORTS_CSV_ID']}/upload/",
                          form: {
                            file: HTTP::FormData::File.new('./reports.csv')
                          })
  puts reports_csv_res
end
