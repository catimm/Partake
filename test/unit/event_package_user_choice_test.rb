# == Schema Information
#
# Table name: event_package_user_choices
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  response                :boolean
#  event_package_option_id :integer
#
# Indexes
#
#  index_event_package_choices_on_user_id                       (user_id)
#  index_event_package_user_choices_on_event_package_option_id  (event_package_option_id)
#

require 'test_helper'

class EventPackageUserChoiceTest < ActiveSupport::TestCase
  test "User must be specified" do
    choice = EventPackageUserChoice.new
    choice.event_package_option_id = 1
    choice.response = true
    assert_raise(ActiveRecord::RecordInvalid) do
      choice.save!
    end
  end

  test "Response must be specified" do
    choice = EventPackageUserChoice.new
    choice.event_package_option_id = 1
    choice.user_id = 1
    assert_raise(ActiveRecord::RecordInvalid) do
      choice.save!
    end
  end

  test "Event Package Option Id must be specified" do
    choice = EventPackageUserChoice.new
    choice.response = false
    choice.user_id = 1
    assert_raise(ActiveRecord::RecordInvalid) do
      choice.save!
    end
  end

  test "Successfully create event package user choice" do
    choice = EventPackageUserChoice.new
    choice.event_package_option_id = 1
    choice.response = false
    choice.user_id = 1
    choice.save!
  end
end
