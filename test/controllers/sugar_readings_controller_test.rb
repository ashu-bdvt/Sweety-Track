require 'test_helper'

class SugarReadingsControllerTest < ActionController::TestCase
  setup do
    @sugar_reading = sugar_readings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sugar_readings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sugar_reading" do
    assert_difference('SugarReading.count') do
      post :create, sugar_reading: {  }
    end

    assert_redirected_to sugar_reading_path(assigns(:sugar_reading))
  end

  test "should show sugar_reading" do
    get :show, id: @sugar_reading
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sugar_reading
    assert_response :success
  end

  test "should update sugar_reading" do
    patch :update, id: @sugar_reading, sugar_reading: {  }
    assert_redirected_to sugar_reading_path(assigns(:sugar_reading))
  end

  test "should destroy sugar_reading" do
    assert_difference('SugarReading.count', -1) do
      delete :destroy, id: @sugar_reading
    end

    assert_redirected_to sugar_readings_path
  end
end
