# == Schema Information
#
# Table name: tracers
#
#  id                    :uuid             not null, primary key
#  name                  :string
#  description           :text
#  photo_file_name       :string
#  photo_content_type    :string
#  photo_file_size       :integer
#  photo_updated_at      :datetime
#  origin                :string
#  kind                  :string
#  longitude             :float
#  latitude              :float
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  icon_url_file_name    :string
#  icon_url_content_type :string
#  icon_url_file_size    :integer
#  icon_url_updated_at   :datetime
#

class Tracer < ApplicationRecord
  has_attached_file :photo
  has_attached_file :icon_url, default_url: '/images/default_marker.png'
  has_many :reports, dependent: :destroy

  validates :name, :description, :photo, :origin, :kind, presence: true
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/
end
