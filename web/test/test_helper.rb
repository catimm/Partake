ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def decode_json(data)
    ActiveSupport::JSON.decode data
  end

  def headers
    { 'CONTENT_TYPE' => 'application/json' }
  end

  def login(email, password)
    json_body = { :user => {:email => email, :password => password } }
    post "/users/sign_in.json", json_body.to_json, headers
    assert_response :success
    json_response = decode_json @response.body
    assert !json_response["token"].blank?
    return json_response
  end

  def signup(email, first_name, last_name, password, password_confirmation, mobile_number, stripe_token)
    json_body = {
      :user => 
      {
        :email => email,
        :password => password,
        :password_confirmation => password_confirmation,
        :first_name => first_name,
        :last_name => last_name,
        :mobile_number => mobile_number
      },
      :stripeToken => stripe_token
    }

    post "/users.json", json_body.to_json, headers
  end

  def createStripeToken
    Stripe.api_key = Figaro.env.stripe_api_key
    response =  Stripe::Token.create(
      :card => {
        :number => "4012888888881881",
        :exp_month => 10,
        :exp_year => 2014,
        :cvc => "314"
      },
    )
    response[:id]
  end
end
