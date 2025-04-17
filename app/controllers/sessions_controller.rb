# frozen_string_literal: true

# Controller responsible for user session management (login and logout)
class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.authenticate_by(email: params[:user][:email], password: params[:user][:password])
    if user
      login user
      redirect_to root_path, notice: 'You have signed successfully'
    else
      @user = User.new(email: params[:user][:email])
      flash[:alert] = 'Invalid email or password'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout current_user
    redirect_to root_path, notice: 'You have been logged out'
  end
end
