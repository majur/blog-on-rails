# frozen_string_literal: true

# Controller for managing users
# Handles user administration tasks for superadmins
class UsersController < ApplicationController
  before_action :authorize_superadmin, only: %i[index edit update show]

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'User information updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def authorize_superadmin
    return if current_user.superadmin?

    redirect_to root_path, alert: 'You are not authorized to perform this action.'
  end

  def user_params
    params.require(:user).permit(:name, :superadmin, :author)
  end
end
