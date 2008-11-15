require 'test_helper'

class CaptchaOnIknowDemosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:captcha_on_iknow_demos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create captcha_on_iknow_demo" do
    assert_difference('CaptchaOnIknowDemo.count') do
      post :create, :captcha_on_iknow_demo => { }
    end

    assert_redirected_to captcha_on_iknow_demo_path(assigns(:captcha_on_iknow_demo))
  end

  test "should show captcha_on_iknow_demo" do
    get :show, :id => captcha_on_iknow_demos(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => captcha_on_iknow_demos(:one).id
    assert_response :success
  end

  test "should update captcha_on_iknow_demo" do
    put :update, :id => captcha_on_iknow_demos(:one).id, :captcha_on_iknow_demo => { }
    assert_redirected_to captcha_on_iknow_demo_path(assigns(:captcha_on_iknow_demo))
  end

  test "should destroy captcha_on_iknow_demo" do
    assert_difference('CaptchaOnIknowDemo.count', -1) do
      delete :destroy, :id => captcha_on_iknow_demos(:one).id
    end

    assert_redirected_to captcha_on_iknow_demos_path
  end
end
