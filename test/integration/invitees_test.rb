require 'test_helper'

class InviteesTest < ActionDispatch::IntegrationTest

  test "Respond to invitation for invalid invitee fails" do
    body = {
      :email => users(:clark).email,
      :token => login(users(:clark).email, "test12345")["token"],
      :accepted => true
    }

    put "/api/v1/events/1/invitees", body.to_json, headers
    assert_response :unauthorized
  end

  test "Respond to invitation for invalid event id fails" do
     body = {
      :email => users(:clark).email,
      :token => login(users(:clark).email, "test12345")["token"],
      :accepted => true
    }

    put "/api/v1/events/9/invitees", body.to_json, headers
    assert_response :not_found
  end

  test "Accept invitation for the first time" do
    invitee = Invitee.where(:user_id => users(:bruce).id, :event_id => 3).first
    assert_not_nil invitee
    assert_nil invitee.accepted
    assert_nil EventTimeUserChoice.where(:user_id => users(:bruce).id, :event_time_option_id => 5).first
    assert_nil EventTimeUserChoice.where(:user_id => users(:bruce).id, :event_time_option_id => 6).first
    assert_nil EventPackageUserChoice.where(:user_id => users(:bruce).id, :event_package_option_id => 6).first
    assert_nil EventPackageUserChoice.where(:user_id => users(:bruce).id, :event_package_option_id => 7).first

    body = {
      :email => users(:bruce).email,
      :token => login(users(:bruce).email, "test12345")["token"],
      :accepted => true,
      :time_choices => [
        {:time_option_id => 5, :response => true},
        {:time_option_id => 6, :response => false}
      ],
      :package_choices =>[
        {:package_option_id => 6, :response => false},
        {:package_option_id => 7, :response => true}
      ]
    }

    put "/api/v1/events/3/invitees", body.to_json, headers
    assert_response :success

    assert Invitee.where(:user_id => users(:bruce).id, :event_id => 3).first.accepted

    choice = EventTimeUserChoice.where(:user_id => users(:bruce).id, :event_time_option_id => 5).first
    assert_not_nil choice
    assert choice.response

    choice = EventTimeUserChoice.where(:user_id => users(:bruce).id, :event_time_option_id => 6).first
    assert_not_nil choice
    assert !choice.response

    choice = EventPackageUserChoice.where(:user_id => users(:bruce).id, :event_package_option_id => 6).first
    assert_not_nil choice
    assert !choice.response

    choice = EventPackageUserChoice.where(:user_id => users(:bruce).id, :event_package_option_id => 7).first
    assert_not_nil choice
    assert choice.response
  end

  test "Decline invitation for the first time" do
    invitee = Invitee.where(:user_id => users(:bruce).id, :event_id => 3).first
    assert_not_nil invitee
    assert_nil invitee.accepted
    assert_nil EventTimeUserChoice.where(:user_id => users(:bruce).id, :event_time_option_id => 5).first
    assert_nil EventTimeUserChoice.where(:user_id => users(:bruce).id, :event_time_option_id => 6).first
    assert_nil EventPackageUserChoice.where(:user_id => users(:bruce).id, :event_package_option_id => 6).first
    assert_nil EventPackageUserChoice.where(:user_id => users(:bruce).id, :event_package_option_id => 7).first

    body = {
      :email => users(:bruce).email,
      :token => login(users(:bruce).email, "test12345")["token"],
      :accepted => false,
    }

    put "/api/v1/events/3/invitees", body.to_json, headers
    assert_response :success

    assert !Invitee.where(:user_id => users(:bruce).id, :event_id => 3).first.accepted

    choice = EventTimeUserChoice.where(:user_id => users(:bruce).id, :event_time_option_id => 5).first
    assert_nil choice

    choice = EventTimeUserChoice.where(:user_id => users(:bruce).id, :event_time_option_id => 6).first
    assert_nil choice

    choice = EventPackageUserChoice.where(:user_id => users(:bruce).id, :event_package_option_id => 6).first
    assert_nil choice

    choice = EventPackageUserChoice.where(:user_id => users(:bruce).id, :event_package_option_id => 7).first
    assert_nil choice
  end

  test "Update response" do
    invitee = Invitee.where(:user_id => users(:chris).id, :event_id => 1).first
    assert_not_nil invitee
    assert invitee.accepted

    assert_not_nil EventTimeUserChoice.where(:user_id => users(:chris).id, :event_time_option_id => 1).first
    assert_not_nil EventTimeUserChoice.where(:user_id => users(:chris).id, :event_time_option_id => 2).first
    assert_not_nil EventPackageUserChoice.where(:user_id => users(:chris).id, :event_package_option_id => 1).first
    assert_not_nil EventPackageUserChoice.where(:user_id => users(:chris).id, :event_package_option_id => 2).first 
    assert_not_nil EventPackageUserChoice.where(:user_id => users(:chris).id, :event_package_option_id => 3).first


    body = {
      :email => users(:chris).email,
      :token => login(users(:chris).email, "test12345")["token"],
      :accepted => false
    }

    put "/api/v1/events/1/invitees", body.to_json, headers
    assert_response :success

    assert !Invitee.where(:user_id => users(:chris).id, :event_id => 1).first.accepted

    choice = EventTimeUserChoice.where(:user_id => users(:chris).id, :event_time_option_id => 1).first
    assert_not_nil choice
    assert !choice.response

    choice = EventTimeUserChoice.where(:user_id => users(:chris).id, :event_time_option_id => 2).first
    assert_not_nil choice
    assert !choice.response

    choice = EventPackageUserChoice.where(:user_id => users(:chris).id, :event_package_option_id => 1).first
    assert_not_nil choice
    assert !choice.response

    choice = EventPackageUserChoice.where(:user_id => users(:chris).id, :event_package_option_id => 2).first
    assert_not_nil choice
    assert !choice.response

    choice = EventPackageUserChoice.where(:user_id => users(:chris).id, :event_package_option_id => 3).first
    assert_not_nil choice
    assert !choice.response
  end

  test "Cancel event" do
    assert_equal events(:one).user_id, users(:ansh_s).id
    assert_nil FinalizedEvent.where(:event_id => events(:one).id).first

    body = {
      :email => users(:ansh_s).email,
      :token => login(users(:ansh_s).email, "test12345")["token"],
      :accepted => false
    }

    put "/api/v1/events/1/invitees", body.to_json, headers
    assert_response :success

    finalized_event = FinalizedEvent.where(:event_id => events(:one).id).first
    assert_not_nil finalized_event
    assert !finalized_event.confirmed

    choice = EventTimeUserChoice.where(:user_id => users(:ansh_s).id, :event_time_option_id => 1).first
    assert_not_nil choice
    assert !choice.response

    choice = EventTimeUserChoice.where(:user_id => users(:ansh_s).id, :event_time_option_id => 2).first
    assert_not_nil choice
    assert !choice.response

    choice = EventPackageUserChoice.where(:user_id => users(:ansh_s).id, :event_package_option_id => 1).first
    assert_not_nil choice
    assert !choice.response

    choice = EventPackageUserChoice.where(:user_id => users(:ansh_s).id, :event_package_option_id => 2).first
    assert_not_nil choice
    assert !choice.response

    choice = EventPackageUserChoice.where(:user_id => users(:ansh_s).id, :event_package_option_id => 3).first
    assert_not_nil choice
    assert !choice.response 
  end
end