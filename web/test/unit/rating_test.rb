# == Schema Information
#
# Table name: ratings
#
#  id         :integer          not null, primary key
#  package_id :integer
#  user_id    :integer
#  rating     :integer
#  category   :string(255)
#  comments   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_ratings_on_package_id  (package_id)
#  index_ratings_on_user_id     (user_id)
#

require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
