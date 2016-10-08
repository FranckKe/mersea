# == Schema Information
#
# Table name: reports
#
#  id                 :uuid             not null, primary key
#  tracer_id          :uuid
#  name               :string
#  email              :string
#  quantity           :integer
#  address            :string
#  longitude          :float
#  latitude           :float
#  description        :text
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  reported_at        :date
#  status             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_reports_on_address      (address)
#  index_reports_on_latitude     (latitude)
#  index_reports_on_longitude    (longitude)
#  index_reports_on_reported_at  (reported_at)
#  index_reports_on_status       (status)
#  index_reports_on_tracer_id    (tracer_id)
#

class Report < ApplicationRecord
  include Concerns::ReportManager

  has_attached_file :photo
  belongs_to :tracer

  validates :tracer_id, :name, :photo, :latitude, :longitude, :reported_at, presence: true
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/
end
