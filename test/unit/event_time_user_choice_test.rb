# == Schema Information
#
# Table name: event_time_user_choices
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  response             :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  event_time_option_id :integer
#
# Indexes
#
#  index_event_time_choices_on_user_id                    (user_id)
#  index_event_time_user_choices_on_event_time_option_id  (event_time_option_id)
#

require 'test_helper'

class EventTimeChoiceTest < ActiveSupport::TestCase
  test "User must be specified" do
    choice = EventTimeUserChoice.new
    choice.event_time_option_id = 1
    choice.response = true
    assert_raise(ActiveRecord::RecordInvalid) do
      choice.save!
    end
  end

  test "Response must be specified" do
    choice = EventTimeUserChoice.new
    choice.event_time_option_id = 1
    choice.user_id = 1
    assert_raise(ActiveRecord::RecordInvalid) do
      choice.save!
    end
  end

  test "Event Time Option Id must be specified" do
    choice = EventTimeUserChoice.new
    choice.response = false
    choice.user_id = 1
    assert_raise(ActiveRecord::RecordInvalid) do
      choice.save!
    end
  end

  test "Successfully create event time user choice" do
    choice = EventTimeUserChoice.new
    choice.event_time_option_id = 1
    choice.response = false
    choice.user_id = 1
    choice.save!
  end
end
