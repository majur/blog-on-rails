require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'email should be present' do
    @user.email = '   '
    assert_not @user.valid?
  end

  test 'email should be downcased and stripped' do
    mixed_case_email = 'TeSt@ExAmPlE.CoM'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase.strip, @user.reload.email
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 6
    assert @user.valid?
  end
end
