# frozen_string_literal: true

# Controller responsible for user registration
# Handles new user sign-ups and account creation
class RegistrationsController < ApplicationController
  before_action :check_registration_enabled, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    @user.superadmin = User.count.zero?

    if @user.save
      create_registration_setting unless Setting.exists?(registration_enabled: true)
      login @user
      redirect_to root_path, notice: 'Registration successful. Check your email.'
    else
      if @user.errors[:email].include?('has already been taken')
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
    Setting.create(blog_name: 'Shiny New Blog', registration_enabled: true)
  end

  def check_registration_enabled
    return if Setting.exists?(registration_enabled: true) || User.count.zero?

    redirect_to root_path,
                alert: 'User registration is not currently enabled.'
  end
end
