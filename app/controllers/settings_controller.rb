class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_superadmin, only: [:edit, :update]

  def edit
    @setting = Setting.find_by(key: 'registration_enabled')
  end

  def update
    @setting = Setting.find_by(key: 'registration_enabled')
    if @setting.update(setting_params)
      redirect_to edit_setting_path(@setting), notice: 'The settings have been updated.'
    else
      render :edit
    end
  end

  private

  def setting_params
    params.require(:setting).permit(:value)
  end

  def authorize_superadmin
    unless current_user && current_user.superadmin?
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end
end