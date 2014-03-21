# == Schema Information
#
# Table name: package_instances
#
#  id                   :integer          not null, primary key
#  package_id           :integer
#  available_start_time :time
#  available_end_time   :time
#  price                :integer
#  min_people           :integer
#  max_people           :integer
#  max_available        :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  cancel_notice        :string(255)
#  available_days       :string(255)
#  advance_notice       :string(255)
#
# Indexes
#
#  index_package_instances_on_package_id  (package_id)
#

require 'test_helper'

class PackageInstanceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
