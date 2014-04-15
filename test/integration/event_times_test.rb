require 'test_helper'

class EventTimesTest < ActionDispatch::IntegrationTest

  test "Get time options fails with uninvited user" do
    token = login(users(:clark).email, "test12345")["token"]
    get "/api/v1/events/1/times/options?email=#{users(:clark).email}&token=#{token}", headers
    assert_response :unauthorized
  end

  test "Get time options" do
    token = login(users(:ansh_s).email, "test12345")["token"]
    get "/api/v1/events/1/times/options?email=#{users(:ansh_s).email}&token=#{token}", headers
    assert_response :success
    json = decode_json @response.body

    assert_equal EventTimeOption.where(:event_id => 1).count, json.count
  end

  test "Get user time choices" do
    token = login(users(:chris).email, "test12345")["token"]
    get "/api/v1/events/2/times?email=#{users(:chris).email}&token=#{token}", headers
    assert_response :success
    json = decode_json @response.body

    assert_equal 2, json.count
  end

  test "Get user time choices fails for uninvited user" do
    token = login(users(:barry).email, "test12345")["token"]
    get "/api/v1/events/2/times?email=#{users(:barry).email}&token=#{token}", headers
    assert_response :unauthorized
  end   

  test "Post time choice of invited user" do
    token = login(users(:chris).email, "test12345")["token"]
    count = EventTimeUserChoice.find(:all).count
    post "/api/v1/events/1/times", {:email => users(:chris).email, :token => token, :event_time_user_choice => {:event_time_option_id => 1, :response => true}}.to_json, headers
    assert_response :success
    assert_equal count+1, EventTimeUserChoice.find(:all).count
  end

  test "Post time choice of uninvited user should fail" do
    token = login(users(:clark).email, "test12345")["token"]
    post "/api/v1/events/1/times", {:email => users(:clark).email, :token => token, :event_time_user_choice => {:event_time_option_id => 1, :response => true}}.to_json, headers
    assert_response :unauthorized
  end

  test "Post invalid time choice should fail" do
    token = login(users(:chris).email, "test12345")["token"]
    post "/api/v1/events/1/times", {:email => users(:chris).email, :token => token, :event_time_user_choice => {:event_time_option_id => 20, :response => true}}.to_json, headers
    assert_response :not_found
  end

  test "Post time choice with no response should fail" do
    token = login(users(:chris).email, "test12345")["token"]
    post "/api/v1/events/1/times", {:email => users(:chris).email, :token => token, :event_time_user_choice => {:event_time_option_id => 1}}.to_json, headers
    assert_response :unprocessable_entity
  end
end

