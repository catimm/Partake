# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  stripe_customer_id     :string(255)
#  authentication_token   :string(255)
#  mobile_number          :integer
#  role                   :string(255)      default("registered"), not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_mobile_number         (mobile_number)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def valid_user
    user = User.new
    user.email = 'john@doe.com'
    user.password = 'foobar12345'
    user.first_name = 'John'
    user.last_name = 'Doe'
    user.mobile_number = 4251234567
    user.role = 'registered'
    return user
  end

  test "create new user" do
    user = valid_user
    user.save!
  end

  test "create new user with malformed email" do
    user = valid_user
    user.email = 'foobar'
    assert_raise(ActiveRecord::RecordInvalid) do
      user.save!
    end
  end

  test "create new user with wrong password confirmation" do
    user = valid_user
    user.password = 'foobar12345'
    user.password_confirmation = 'baz12345'
    assert_raise(ActiveRecord::RecordInvalid) do
      user.save!
    end
  end

  test "ensure email is unique" do
    user = valid_user
    user.email = "ansh_s@hotmail.com"
    assert_raise(ActiveRecord::RecordInvalid) do
      user.save!
    end   
  end

  test "ensure mobile number is unique" do
    user = valid_user
    user.mobile_number = 4259907778
    assert_raise(ActiveRecord::RecordInvalid) do
      user.save!
    end
  end

  test "ensure mobile number is present" do
    user = valid_user
    user.mobile_number = nil
    assert_raise(ActiveRecord::RecordInvalid) do
      user.save!
    end
  end

  test "valid user does not require email and password" do
    user = User.new
    user.first_name = 'John'
    user.last_name = 'Doe'
    user.mobile_number = 4251234567
    user.save!
  end

  test "user with email requires password" do
    user = valid_user
    user.password = nil
    assert_raise(ActiveRecord::RecordInvalid) do
      user.save!
    end
  end

  test "modify user attribute does not require password" do
    user = User.find(1)
    user.mobile_number = 8983246712
    user.save!
  end

  test "role cannot be blank" do
    user = valid_user
    user.role = nil
    assert_raise(ActiveRecord::RecordInvalid) do
      user.save!
    end

    user = valid_user
    user.role = ""
    assert_raise(ActiveRecord::RecordInvalid) do
      user.save!
    end
  end

  test "role must be registered or unregistered" do
    user = valid_user
    user.role = "wrong_value"
    assert_raise(ActiveRecord::RecordInvalid) do
      user.save!
    end
  end
end
