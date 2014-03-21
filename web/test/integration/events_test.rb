require 'test_helper'

class EventsTest < ActionDispatch::IntegrationTest

  test "Get all events" do
    token = login(users(:ansh_s).email, "test12345")["token"]
    get "/api/v1/events.json?email=#{users(:ansh_s).email}&token=#{token}", headers
    assert_response :success
    json = decode_json @response.body

    invitees = Invitee.where(:user_id => 1)
    assert_equal invitees.count, json.count

    i = 0
    invitees.each {|invitee|
      assert_equal invitee.event.id, json[i]["event_id"]
      assert_equal invitee.event.organizer.first_name, json[i]["organizer"]["first_name"]
      assert_equal invitee.event.organizer.last_name, json[i]["organizer"]["last_name"]
      assert_equal invitee.event.organizer.email, json[i]["organizer"]["email"]

      if invitee.event.finalized_event.nil?
        assert_equal StatusMessages::InviteSent, json[i]["status"]
      else
        assert_equal StatusMessages::Confirmed, json[i]["status"]
        assert_equal invitee.event.finalized_event.timestamp, json[i]["timestamp"]
      end

      i += 1
    }
  end

  test "Get event for user who has not responded" do
    token = login(users(:dick).email, "test12345")["token"]
    get "/api/v1/events.json?email=#{users(:dick).email}&token=#{token}", headers
    assert_response :success
    json = decode_json @response.body

    invitees = Invitee.where(:user_id => 5)
    assert_equal 1, json.count
    invitee = invitees.first

    assert_equal invitee.event.id, json[0]["event_id"]
    assert_equal invitee.event.organizer.first_name, json[0]["organizer"]["first_name"]
    assert_equal invitee.event.organizer.last_name, json[0]["organizer"]["last_name"]
    assert_equal invitee.event.organizer.email, json[0]["organizer"]["email"]
    assert_equal StatusMessages::ResponseDue, json[0]["status"]
  end

  test "Get events for user who has responded but events are unconfirmed" do
    token = login(users(:clark).email, "test12345")["token"]
    get "/api/v1/events.json?email=#{users(:clark).email}&token=#{token}", headers
    assert_response :success
    json = decode_json @response.body

    invitees = Invitee.where(:user_id => 4)
    assert_equal 1, json.count
    invitee = invitees.first

    assert_equal invitee.event.id, json[0]["event_id"]
    assert_equal invitee.event.organizer.first_name, json[0]["organizer"]["first_name"]
    assert_equal invitee.event.organizer.last_name, json[0]["organizer"]["last_name"]
    assert_equal invitee.event.organizer.email, json[0]["organizer"]["email"]
    assert_equal StatusMessages::ResponseSent, json[0]["status"]
  end

  test "Get declined events" do
    token = login(users(:bruce).email, "test12345")["token"]
    get "/api/v1/events.json?email=#{users(:bruce).email}&token=#{token}", headers
    assert_response :success
    json = decode_json @response.body

    invitees = Invitee.where(:user_id => 3, :event_id => 1)
    assert_equal 3, json.count
    invitee = invitees.first

    json_event = json.select { |event| event["event_id"] == 1}.first
    assert_equal 1, json_event["event_id"]
    assert_equal invitee.event.id, json_event["event_id"]
    assert_equal invitee.event.organizer.first_name, json_event["organizer"]["first_name"]
    assert_equal invitee.event.organizer.last_name, json_event["organizer"]["last_name"]
    assert_equal invitee.event.organizer.email, json_event["organizer"]["email"]
    assert_equal StatusMessages::DeclinedSent, json_event["status"]   
  end

  test "Get all events fails with invalid token" do
    get "/api/v1/events.json?email=#{users(:ansh_s).email}&token=12345", headers
    assert_response :unauthorized
  end

  test "Create new event and invite registered users" do
    count = Event.find(:all).count
    old_id = Event.last.id

    token = login(users(:clark).email, "test12345")["token"]
    body = {
      :email => users(:clark).email,
      :token => token,
      :invitees => [
        {:mobile_number => users(:bruce).mobile_number, :first_name => users(:bruce).first_name, :last_name => users(:bruce).last_name},
        {:mobile_number => users(:dick).mobile_number, :first_name => users(:dick).first_name, :last_name => users(:dick).last_name},
      ]
    }

    post "/api/v1/events", body.to_json, headers
    assert_response :success

    json = decode_json @response.body
    event = Event.find(json["event_id"])

    # verify event details are correct
    assert_not_nil event
    assert_not_equal old_id, event.id
    assert_equal count+1, Event.find(:all).count
    assert_equal users(:clark).email, event.organizer.email

    # verify invitees were created
    assert_equal 2, Invitee.where(:event_id => event.id).count
    Invitee.where(:event_id => event.id).each {|invitee|
      assert [users(:bruce).id, users(:dick).id].include? invitee.user_id
    }
  end

  test "Show event for invalid invitee fails" do
    token = login(users(:clark).email, "test12345")["token"]
    get "/api/v1/events/1?email=#{users(:clark).email}&token=#{token}", headers
    assert_response :unauthorized
  end

  test "Show event for invalid event id fails" do
    token = login(users(:clark).email, "test12345")["token"]
    get "/api/v1/events/9?email=#{users(:clark).email}&token=#{token}", headers
    assert_response :not_found
  end

  test "Show event for canceled event" do
    token = login(users(:barry).email, "test12345")["token"]
    get "/api/v1/events/4?email=#{users(:barry).email}&token=#{token}", headers

    assert_response :success
    json = decode_json @response.body

    assert_equal 4, json["event_id"]
    assert !json["confirmed"]
    assert_equal users(:barry).id, json["organizer"]["id"]
    assert_equal users(:barry).first_name, json["organizer"]["first_name"]
    assert_equal users(:barry).last_name, json["organizer"]["last_name"]
    assert_equal users(:barry).email, json["organizer"]["email"]
    assert_equal 2, json["invitees"].count
    json["invitees"].each {|invitee|
      assert [users(:barry).id, users(:hal).id].include? invitee["user_id"]
      assert [users(:barry).mobile_number, users(:hal).mobile_number].include? invitee["mobile_number"]
      assert [users(:barry).first_name, users(:hal).first_name].include? invitee["first_name"]
      assert [users(:barry).last_name, users(:hal).last_name].include? invitee["last_name"]
    }
  end

  test "Show event for confirmed event" do
    token = login(users(:bruce).email, "test12345")["token"]
    get "/api/v1/events/3?email=#{users(:bruce).email}&token=#{token}", headers

    assert_response :success
    json = decode_json @response.body

    assert_equal 3, json["event_id"]

    event = Event.find(3)

    assert json["confirmed"]
    assert_equal users(:ansh_s).id, json["organizer"]["id"]
    assert_equal users(:ansh_s).first_name, json["organizer"]["first_name"]
    assert_equal users(:ansh_s).last_name, json["organizer"]["last_name"]
    assert_equal users(:ansh_s).email, json["organizer"]["email"]
    assert_equal event.finalized_event.timestamp, json["time_option"]
    assert_not_nil json["package_option"]
    assert_equal event.finalized_event.package_instance.id, json["package_option"]["package_instance_id"]
    assert_equal event.finalized_event.package_instance.package.id, json["package_option"]["package_id"]
    assert_equal event.finalized_event.package_instance.price, json["package_option"]["price"]
    assert_equal event.finalized_event.package_instance.package.title, json["package_option"]["title"]
    assert_equal event.finalized_event.package_instance.package.description, json["package_option"]["description"]
    assert_equal event.finalized_event.package_instance.package.image_url, json["package_option"]["image_url"]
  end

  test "Show event for event still being planned" do
    token = login(users(:chris).email, "test12345")["token"]
    get "/api/v1/events/1?email=#{users(:chris).email}&token=#{token}", headers

    assert_response :success
    json = decode_json @response.body

    event = Event.find(1)

    assert_equal 1, json["event_id"]
    assert_nil json["confirmed"]
    assert_equal event.event_time_options.count, json["time_options"].count
    json["time_options"].each { |time_option|
      expected_time_option = EventTimeOption.find(time_option["id"])
      assert_not_nil expected_time_option
      assert_equal expected_time_option.time, time_option["time"]
      assert_equal expected_time_option.upvotes, time_option["upvotes"]
    }

    assert_equal event.event_package_options.count, json["package_options"].count
    json["package_options"].each { |package_option|
      expected_package_instance = PackageInstance.find(package_option["package_instance_id"])
      assert_not_nil expected_package_instance
      assert_equal expected_package_instance.price, package_option["price"]
      assert_equal expected_package_instance.package.title, package_option["title"]
    }
  end

  test "Create new event and invite unregistered users" do
    event_count = Event.find(:all).count
    old_id = Event.last.id
    user_count = User.find(:all).count

    new_user_1_number = 4250000000
    new_user_1_first_name = "Master"
    new_user_1_last_name = "Chief"
    new_user_2_number = 4251111111
    new_user_2_first_name = "Solid"
    new_user_2_last_name = "Snake"

    token = login(users(:clark).email, "test12345")["token"]
    body = {
      :email => users(:clark).email,
      :token => token,
      :invitees => [
        {:mobile_number => new_user_1_number, :first_name => new_user_1_first_name, :last_name => new_user_1_last_name},
        {:mobile_number => new_user_2_number, :first_name => new_user_2_first_name, :last_name => new_user_2_last_name},
      ]
    }

    post "/api/v1/events", body.to_json, headers
    assert_response :success

    json = decode_json @response.body
    event = Event.find(json["event_id"])

    # verify event details are correct
    assert_not_nil event
    assert_not_equal old_id, event.id
    assert_equal event_count+1, Event.find(:all).count
    assert_equal users(:clark).email, event.organizer.email

    # verify unregistered users were created
    new_users = []
    assert_equal user_count+2, User.find(:all).count
    user = User.find_by_mobile_number(new_user_1_number)
    assert_not_nil user
    assert_equal new_user_1_first_name, user.first_name
    assert_equal new_user_1_last_name, user.last_name
    new_users << user.id

    user = User.find_by_mobile_number(new_user_2_number)
    assert_not_nil user
    assert_equal new_user_2_first_name, user.first_name
    assert_equal new_user_2_last_name, user.last_name
    new_users << user.id

    assert_equal 2, Invitee.where(:event_id => event.id).count
    Invitee.where(:event_id => event.id).each {|invitee|
      assert new_users.include? invitee.user_id
      assert !invitee.uid.blank?, "uid was not generated for unregistered invitee"
    }   
  end

  test "Create new event and invite users and add package options" do
    count = Event.find(:all).count
    old_id = Event.last.id
    package_option_count = EventPackageOption.find(:all).count

    token = login(users(:clark).email, "test12345")["token"]
    body = {
      :email => users(:clark).email,
      :token => token,
      :invitees => [
        {:mobile_number => users(:bruce).mobile_number, :first_name => users(:bruce).first_name, :last_name => users(:bruce).last_name},
        {:mobile_number => users(:dick).mobile_number, :first_name => users(:dick).first_name, :last_name => users(:dick).last_name},
      ],
      :package_options => [2, 4]
    }

    post "/api/v1/events", body.to_json, headers
    assert_response :success

    json = decode_json @response.body
    event = Event.find(json["event_id"])

    # verify event details are correct
    assert_not_nil event
    assert_not_equal old_id, event.id
    assert_equal count+1, Event.find(:all).count
    assert_equal users(:clark).email, event.organizer.email

    # verify package options
    assert_equal package_option_count+2, EventPackageOption.find(:all).count
    assert_equal 1, EventPackageOption.where(:event_id => event.id, :package_instance_id => 2).count
    assert_equal 1, EventPackageOption.where(:event_id => event.id, :package_instance_id => 4).count
  end

  test "Create new event and add package options" do
    count = Event.find(:all).count
    old_id = Event.last.id
    package_option_count = EventPackageOption.find(:all).count

    token = login(users(:clark).email, "test12345")["token"]
    body = {
      :email => users(:clark).email,
      :token => token,
      :package_options => [2, 4]
    }

    post "/api/v1/events", body.to_json, headers
    assert_response :success

    json = decode_json @response.body
    event = Event.find(json["event_id"])

    # verify event details are correct
    assert_not_nil event
    assert_not_equal old_id, event.id
    assert_equal count+1, Event.find(:all).count
    assert_equal users(:clark).email, event.organizer.email

    # verify package options
    assert_equal package_option_count+2, EventPackageOption.find(:all).count
    assert_equal 1, EventPackageOption.where(:event_id => event.id, :package_instance_id => 2).count
    assert_equal 1, EventPackageOption.where(:event_id => event.id, :package_instance_id => 4).count
  end

  test "Create new event and add time options" do
    count = Event.find(:all).count
    old_id = Event.last.id
    time_option_count = EventTimeOption.find(:all).count
    time1 = '2013-12-01 18:00:00 -0800'
    time2 = '2013-12-02 20:00:00 -0800'

    token = login(users(:clark).email, "test12345")["token"]
    body = {
      :email => users(:clark).email,
      :token => token,
      :time_options => [time1, time2]
    }

    post "/api/v1/events", body.to_json, headers
    assert_response :success

    json = decode_json @response.body
    event = Event.find(json["event_id"])

    # verify event details are correct
    assert_not_nil event
    assert_not_equal old_id, event.id
    assert_equal count+1, Event.find(:all).count
    assert_equal users(:clark).email, event.organizer.email

    # verify package options
    assert_equal time_option_count+2, EventTimeOption.find(:all).count
    assert_equal 1, EventTimeOption.where(:event_id => event.id, :time => DateTime.parse(time1)).count
    assert_equal 1, EventTimeOption.where(:event_id => event.id, :time => DateTime.parse(time2)).count
  end

  test "Create new event with invalid credentials fails" do
    invalid_token = "12345"
    post "/api/v1/events?email=#{users(:clark).email}&token=#{invalid_token}", headers
    assert_response :unauthorized
  end

end
