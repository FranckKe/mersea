# == Schema Information
#
# Table name: reports
#
#  id                 :uuid             not null, primary key
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
#  reported_at        :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Report < ApplicationRecord
  has_attached_file :photo

  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/
end
