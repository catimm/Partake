require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  test "show event page" do
    get :show, {:id => 1, :uid => "abcdefghi"}
    assert_response :success
  end

  test "show event page for invalid uid fails" do
    get :show, {:id => 1, :uid => "invalidcode"}
    assert_response :not_found
  end

  test "show event page for invalid event id fails" do
    get :show, {:id => 100, :uid => "abcdefghi"}
    assert_response :not_found
  end

  test "post response to event for invalid uid fails" do
    post :show, {:id => 1, :uid => "invalidcode"}
    assert_response :not_found
  end

  test "post response to event for invalid event id fails" do
    post :show, {:id => 100, :uid => "abcdefghi"}
    assert_response :not_found
  end

  test "post accept" do
    #  make sure this user hasn't submitted anything yet
    assert_equal 0, EventTimeUserChoice.where(:user_id => users(:scott).id).count
    assert_equal 0, EventPackageUserChoice.where(:user_id => users(:scott).id).count
    time_options = EventTimeOption.where(:event_id => 1)
    package_options = EventPackageOption.where(:event_id => 1)
    assert time_options.count > 0
    assert package_options.count > 0

    post :invite_response, {:id => 1, :uid => "tiwksowa", :accept => "Accept"}
    assert_response :success

    assert_equal time_options.count, EventTimeUserChoice.where(:user_id => users(:scott).id).count
    assert_equal package_options.count, EventPackageUserChoice.where(:user_id => users(:scott).id).count

    time_options.each {|time_option|
      time_choice = EventTimeUserChoice.where(:user_id => users(:scott).id, :event_time_option_id => time_option.id).first
      assert_not_nil time_choice
      assert time_choice.response
    }

    package_options.each {|package_option|
      package_choice = EventPackageUserChoice.where(:user_id => users(:scott).id, :event_package_option_id => package_option.id).first
      assert_not_nil package_choice
      assert package_choice.response
    }
  end

  test "post decline" do
    #  make sure this user hasn't submitted anything yet
    assert_equal 0, EventTimeUserChoice.where(:user_id => users(:scott).id).count
    assert_equal 0, EventPackageUserChoice.where(:user_id => users(:scott).id).count
    time_options = EventTimeOption.where(:event_id => 1)
    package_options = EventPackageOption.where(:event_id => 1)
    assert time_options.count > 0
    assert package_options.count > 0

    post :invite_response, {:id => 1, :uid => "tiwksowa", :confirm => "Decline"}
    assert_response :success

    assert_equal time_options.count, EventTimeUserChoice.where(:user_id => users(:scott).id).count
    assert_equal package_options.count, EventPackageUserChoice.where(:user_id => users(:scott).id).count

    time_options.each {|time_option|
      time_choice = EventTimeUserChoice.where(:user_id => users(:scott).id, :event_time_option_id => time_option.id).first
      assert_not_nil time_choice
      assert !time_choice.response
    }

    package_options.each {|package_option|
      package_choice = EventPackageUserChoice.where(:user_id => users(:scott).id, :event_package_option_id => package_option.id).first
      assert_not_nil package_choice
      assert !package_choice.response
    }
  end
end
