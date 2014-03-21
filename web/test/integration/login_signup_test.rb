require 'test_helper'

# tests getting various data, such as active events, old events, current packages, etc
class LoginSignUpTest < ActionDispatch::IntegrationTest
  fixtures :users, :venues

  test "Login" do
    response = login(users(:ansh_s).email, "test12345")
    assert_equal users(:ansh_s).email, response["email"]
    assert_equal users(:ansh_s).first_name, response["first_name"]
    assert_equal users(:ansh_s).last_name, response["last_name"]
    assert_equal users(:ansh_s).mobile_number, response["mobile_number"]
  end

  test "Login failure" do
    json_body = { :user => {:email => users(:ansh_s).email, :password => "wrongpassword" } }
    post "/users/sign_in.json", json_body.to_json, headers
    assert_response :unauthorized
  end

  test "Sign up" do
    initial_count = User.find(:all).count

    email = "russell@seahawks.com"
    first_name = "Russell"
    last_name = "Wilson"
    mobile_number = "4258888888"
    password = "test12345"

    signup(email, first_name, last_name, password, password, mobile_number, createStripeToken)

    assert_response :success
    assert_equal initial_count+1, User.find(:all).count
    u = User.last
    assert_equal email, u.email
    assert_equal last_name, u.last_name
    assert_equal mobile_number.to_i, u.mobile_number
  end

  test "Sign up failure" do
    initial_count = User.find(:all).count

    email = "russell@seahawks.com"
    first_name = "Russell"
    last_name = "Wilson"
    mobile_number = "4258888888"

    signup(email, first_name, last_name, "test12345", "wrongpassword", mobile_number, createStripeToken)
    assert_response :unprocessable_entity
    assert_equal initial_count, User.find(:all).count
  end

  test "Sign up and sign in" do
    email = "russell@seahawks.com"
    first_name = "Russell"
    last_name = "Wilson"
    mobile_number = "4258888888"
    password = "test12345"

    signup(email, first_name, last_name, password, password, mobile_number, createStripeToken)
    assert_response :success

    # pretend user confirmed their account
    u = User.last
    u.confirmed_at = Time.now
    u.save!

    response = login(email, password)
    assert_equal u.email, response["email"]
    assert_equal u.first_name, response["first_name"]
    assert_equal u.last_name, response["last_name"]
    assert_equal u.mobile_number, response["mobile_number"]   
  end


  # test "Update Stripe customer id" do
  #   id = users(:ansh_s).id
  # end

end
