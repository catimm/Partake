# == Schema Information
#
# Table name: finalized_events
#
#  id                  :integer          not null, primary key
#  event_id            :integer
#  package_instance_id :integer
#  timestamp           :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  confirmed           :boolean
#
# Indexes
#
#  index_finalized_events_on_event_id             (event_id)
#  index_finalized_events_on_package_instance_id  (package_instance_id)
#

require 'test_helper'

class FinalizedEventTest < ActiveSupport::TestCase
  test "confirmed must be present" do
    finalized_event = FinalizedEvent.new
    finalized_event.event_id = 1
    finalized_event.package_instance_id = 1
    assert_raise(ActiveRecord::RecordInvalid) do
      finalized_event.save!
    end   
  end
end
