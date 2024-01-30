class RegistrationsController < ApplicationController
  before_action :check_registration_enabled, only: [:new]

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    @user.superadmin = User.count.zero?

    if @user.save
      # Create settings record when the first user is created
      create_registration_setting unless Setting.exists?(key: 'registration_enabled')

      login @user
      redirect_to root_path, notice: 'Registration successful. Check your email.'
    else
      if @user.errors[:email].include?("has already been taken")
        flash.now[:alert] = 'Email has already been taken. If this is your account, please log in.'
      end
      render :new, status: :unprocessable_entity
    end
  end
  private

  def registration_params
      params.require(:user).permit(:email, :password, :password_confirmation, :superadmin)
  end

  def create_registration_setting
    Setting.create(key: 'registration_enabled', value: '1')
  end

  def check_registration_enabled
    setting = Setting.find_by(key: 'registration_enabled')
    if setting&.value == '0'
      redirect_to root_path, alert: 'User registration is not currently enabled.'
    end
  end
end
