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
#  user_id            :uuid
#
# Indexes
#
#  index_reports_on_address      (address)
#  index_reports_on_latitude     (latitude)
#  index_reports_on_longitude    (longitude)
#  index_reports_on_reported_at  (reported_at)
#  index_reports_on_status       (status)
#  index_reports_on_tracer_id    (tracer_id)
#  index_reports_on_user_id      (user_id)
#

class Report < ApplicationRecord
  include Concerns::ReportManager

  has_attached_file :photo
  belongs_to :tracer
  belongs_to :user, optional: true

  validates :tracer_id, :name, :latitude, :longitude, :reported_at, presence: true
  validates :photo, presence: true, if: -> { !self.user&.senior && self.status != 'accepted' }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/

  rails_admin do
    list do
      exclude_fields :longitude, :latitude, :email
    end
    show do
      include_all_fields
      exclude_fields :latitude, :status
      field :address
      field :description
      field :status, :state
      field :longitude do
        pretty_value do
          bindings[:view].tag(:div, { id: 'map', class: 'map', 'data-lng': bindings[:object].longitude, 'data-lat': bindings[:object].latitude })
        end
      end
    end
  end
end
