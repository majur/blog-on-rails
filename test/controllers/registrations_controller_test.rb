require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  setup do
    @user_params = {
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password'
    }
  end

  test 'should create user' do
    assert_difference('User.count') do
      post :create, params: { user: @user_params }
    end

    assert_redirected_to root_path
    assert_equal 'Registration successful. Check your email.', flash[:notice]
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

  test 'should not create superadmin on subsequent user creation' do
    # Create a superadmin first
    User.create(email: 'superadmin@example.com', password: 'password', password_confirmation: 'password', superadmin: true)

    assert_difference('User.count') do
      post :create, params: { user: @user_params }
    end

    assert_not assigns(:user).superadmin, 'Subsequent users should not be superadmins'
  end

end
