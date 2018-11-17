# == Schema Information
#
# Table name: tracers
#
#  id          :uuid             not null, primary key
#  name        :string
#  description :text
#  origin      :string
#  kind        :string
#  longitude   :float
#  latitude    :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  color       :string
#

class Tracer < ApplicationRecord
  include Concerns::TracerManager

  has_one_attached :photo
  has_many :reports, dependent: :destroy

  validates :name, :description, :origin, :kind, presence: true
  validates :photo, attached: true, content_type: ['image/png', 'image/jpeg', 'image/tiff', 'image/webp']
end
