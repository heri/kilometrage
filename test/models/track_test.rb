# == Schema Information
#
# Table name: tracks
#
#  id                     :integer          not null, primary key
#  rental_id              :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  recording_file_name    :string
#  recording_content_type :string
#  recording_file_size    :integer
#  recording_updated_at   :datetime
#  mileage                :float            default("0.0")
#

require 'test_helper'

class TrackTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
