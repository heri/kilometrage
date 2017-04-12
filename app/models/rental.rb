# == Schema Information
#
# Table name: rentals
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Rental < ActiveRecord::Base
  has_many :tracks
  validates :name, presence: true
end
