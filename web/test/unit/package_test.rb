# == Schema Information
#
# Table name: packages
#
#  id           :integer          not null, primary key
#  venue_id     :integer
#  package_type :string(255)
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  enabled      :boolean
#  title        :string(255)
#  image_url    :string(255)
#
# Indexes
#
#  index_packages_on_venue_id  (venue_id)
#

require 'test_helper'

class PackageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
