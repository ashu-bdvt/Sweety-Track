require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  test "should get daily" do
    get :daily
    assert_response :success
  end

  test "should get month_to_date" do
    get :month_to_date
    assert_response :success
  end

  test "should get monthly" do
    get :monthly
    assert_response :success
  end

end
