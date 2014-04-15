# == Schema Information
#
# Table name: event_time_options
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  time       :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_event_time_options_on_event_id  (event_id)
#

require 'test_helper'

class EventTimeOptionTest < ActiveSupport::TestCase
  test "upvotes" do
    time_option = EventTimeOption.find(1)
    assert_equal 2, time_option.upvotes
  end

  test "downvotes" do
    time_option = EventTimeOption.find(2)
    assert_equal 1, time_option.downvotes
  end
end
