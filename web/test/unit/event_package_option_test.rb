# == Schema Information
#
# Table name: event_package_options
#
#  id                  :integer          not null, primary key
#  event_id            :integer
#  package_instance_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_event_package_options_on_event_id             (event_id)
#  index_event_package_options_on_package_instance_id  (package_instance_id)
#

require 'test_helper'

class EventPackageOptionTest < ActiveSupport::TestCase
  test "upvotes" do
    time_option = EventPackageOption.find(2)
    assert_equal time_option.upvotes, 1
  end

  test "downvotes" do
    time_option = EventPackageOption.find(2)
    assert_equal time_option.downvotes, 1
  end
end
