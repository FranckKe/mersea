# == Schema Information
#
# Table name: tracers
#
#  id                 :uuid             not null, primary key
#  name               :string
#  description        :text
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  origin             :string
#  type               :string
#  longitude          :float
#  latitude           :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Tracer < ApplicationRecord
  has_attached_file :photo
  has_many :reports, dependent: :destroy

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/
end
