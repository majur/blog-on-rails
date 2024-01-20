class RegistrationsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)
    if @user.save
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
      params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
