# == Schema Information
#
# Table name: invitees
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  user_id    :integer
#  uid        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  accepted   :boolean
#
# Indexes
#
#  index_invitees_on_event_id  (event_id)
#  index_invitees_on_user_id   (user_id)
#

require 'test_helper'

class InviteeTest < ActiveSupport::TestCase
  test "uid must be unique" do
    invitee = Invitee.new
    invitee.event = Event.first
    invitee.user = User.first
    invitee.uid = "abcdefg"
    invitee.save!

    invitee = Invitee.new
    invitee.event = Event.find(2)
    invitee.user = User.find(2)
    invitee.uid = "abcdefg"
    assert_raise(ActiveRecord::RecordInvalid) do
      invitee.save!
    end

    invitee.uid = "efghijk"
    invitee.save!
  end

  test "uid can be blank" do
    invitee = Invitee.new
    invitee.event = Event.first
    invitee.user = User.first
    invitee.uid = nil
    invitee.save!

    invitee = Invitee.new
    invitee.event = Event.find(2)
    invitee.user = User.find(2)
    invitee.uid = nil
    invitee.save!
  end
end
