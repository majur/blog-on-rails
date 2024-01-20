require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
  end

  test "should redirect to root_path when not logged in" do
    get :some_protected_action
    assert_redirected_to root_path
    assert_equal "You must be logged in to do that.", flash[:alert]
  end

  test "should set current_user when authenticated from session" do
    session[:user_id] = @user.id
    get :some_protected_action
    assert_equal @user, assigns(:current_user)
  end

  test "should check if user is signed in" do
    session[:user_id] = @user.id
    get :some_protected_action
    assert_equal true, assigns(:user_signed_in?)
  end

  test "should log in user and set session when login called" do
    post :login, params: { user: { username: @user.username, password: 'password' } }
    assert_equal @user, assigns(:current_user)
    assert_equal @user.id, session[:user_id]
  end

  test "should log out user and reset session when logout called" do
    session[:user_id] = @user.id
    delete :logout
    assert_nil assigns(:current_user)
    assert_nil session[:user_id]
  end
end
