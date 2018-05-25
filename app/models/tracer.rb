# frozen_string_literal: true

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
#  kind               :string
#  longitude          :float
#  latitude           :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  color              :string
#

class Tracer < ApplicationRecord
  include Concerns::TracerManager

  has_one_attached :photo
  has_many :reports, dependent: :destroy

  validates :name, :description, :photo, :origin, :kind, presence: true
  validates :photo, image: true
end
