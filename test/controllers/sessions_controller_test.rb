require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
    fixtures :users # Load the 'users' fixture set

    def setup
      @user = users(:example) # Reference the 'example_user' fixture
    end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create session with valid credentials" do
    post :create, params: { email: @user.email, password: 'password' }
    assert_redirected_to root_path
    assert_equal "You have signed successfully", flash[:notice]
    assert_equal @user.id, session[:user_id]
  end

  test "should not create session with invalid credentials" do
    post :create, params: { email: @user.email, password: 'wrong_password' }
    assert_response :unprocessable_entity
    assert_template :new
    assert_equal "Invalid email or password", flash[:alert]
    assert_nil session[:user_id]
  end

  test "should destroy session" do
    delete :destroy
    assert_redirected_to root_path
    assert_equal "You have been logged out", flash[:notice]
    assert_nil session[:user_id]
  end
end
