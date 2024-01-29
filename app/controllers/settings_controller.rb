class SettingsController < ApplicationController
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
end