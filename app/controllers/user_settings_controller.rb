class UserSettingsController < ApplicationController
  before_action :authenticate_user!

  def edit
  end

  def update
    if current_user.update(user_settings_params)
      redirect_to root_path, notice: "Your name has been updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_settings_params
    params.require(:user).permit(:name)
  end
end
