# frozen_string_literal: true

# Controller responsible for managing application settings
# Only superadmin users can edit and update settings
class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_superadmin, only: %i[edit update]

  def edit; end

  def update
    if @settings.update(setting_params)
      redirect_to edit_setting_path, notice: 'The settings have been updated.'
    else
      render :edit
    end
  end

  private

  def setting_params
    params.require(:setting).permit(:registration_enabled, :blog_name)
  end

  def authorize_superadmin
    return if current_user&.superadmin?

    redirect_to root_path, alert: 'You are not authorized to access this page.'
  end
end
