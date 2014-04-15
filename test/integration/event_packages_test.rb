require 'test_helper'

class EventPackagesTest < ActionDispatch::IntegrationTest

  test "Get packages options fails with uninvited user" do
    token = login(users(:clark).email, "test12345")["token"]
    get "/api/v1/events/1/packages/options?email=#{users(:clark).email}&token=#{token}", headers
    assert_response :unauthorized
  end

  test "Get package options" do
    token = login(users(:ansh_s).email, "test12345")["token"]
    get "/api/v1/events/1/packages/options?email=#{users(:ansh_s).email}&token=#{token}", headers
    assert_response :success
    json = decode_json @response.body

    assert_equal EventPackageOption.where(:event_id => 1).count, json.count
  end

  test "Get user package choices" do
    token = login(users(:chris).email, "test12345")["token"]
    get "/api/v1/events/2/packages?email=#{users(:chris).email}&token=#{token}", headers
    assert_response :success
    json = decode_json @response.body

    assert_equal 2, json.count
  end

  test "Get user package choices fails for uninvited user" do
    token = login(users(:barry).email, "test12345")["token"]
    get "/api/v1/events/2/packages?email=#{users(:barry).email}&token=#{token}", headers
    assert_response :unauthorized
  end   

  test "Post package choice of invited user" do
    token = login(users(:chris).email, "test12345")["token"]
    count = EventPackageUserChoice.find(:all).count
    post "/api/v1/events/1/packages", {:email => users(:chris).email, :token => token, :event_package_user_choice => {:event_package_option_id => 1, :response => true}}.to_json, headers
    assert_response :success
    assert_equal count+1, EventPackageUserChoice.find(:all).count
  end

  test "Post package choice of uninvited user should fail" do
    token = login(users(:clark).email, "test12345")["token"]
    post "/api/v1/events/1/packages", {:email => users(:clark).email, :token => token, :event_package_user_choice => {:event_package_option_id => 1, :response => true}}.to_json, headers
    assert_response :unauthorized
  end

  test "Post invalid package choice should fail" do
    token = login(users(:chris).email, "test12345")["token"]
    post "/api/v1/events/1/packages", {:email => users(:chris).email, :token => token, :event_package_user_choice => {:event_package_option_id => 20, :response => true}}.to_json, headers
    assert_response :not_found
  end

  test "Post package choice with no response should fail" do
    token = login(users(:chris).email, "test12345")["token"]
    post "/api/v1/events/1/packages", {:email => users(:chris).email, :token => token, :event_package_user_choice => {:event_package_option_id => 1}}.to_json, headers
    assert_response :unprocessable_entity
  end
end
