require 'test_helper'

class VenuesTest < ActionDispatch::IntegrationTest

  test "Get all venues" do
    token = login(users(:ansh_s).email, "test12345")["token"]
    get "/api/v1/venues.json?email=#{users(:ansh_s).email}&token=#{token}", headers
    assert_response :success
    json = decode_json @response.body
    assert_equal venues(:altura).name, json[0]["name"]
    assert_equal venues(:taylor).name, json[1]["name"]
  end

end
