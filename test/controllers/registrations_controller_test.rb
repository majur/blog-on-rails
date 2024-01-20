require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  setup do
    @user_params = {
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password'
    }
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test 'should create user' do
    assert_difference('User.count') do
      post :create, params: { user: @user_params }
    end

    assert_redirected_to root_path
    assert_equal 'User successfully created', flash[:notice]
  end

  test 'should not create user with invalid params' do
    # Simulate an invalid user creation by providing empty email
    @user_params[:email] = ''
    
    assert_no_difference('User.count') do
      post :create, params: { user: @user_params }
    end

    assert_response :unprocessable_entity
    assert_template :new
  end
end
