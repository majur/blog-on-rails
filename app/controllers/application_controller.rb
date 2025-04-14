# frozen_string_literal: true

# Base controller class that all other controllers inherit from
# Provides common functionality for authentication and session management
class ApplicationController < ActionController::Base
  before_action :set_settings

  private

  def set_settings
    @settings = Setting.first_or_initialize
  end

  def authenticate_user!
    return if user_signed_in? || (controller_name == 'posts' && action_name == 'show')

    redirect_to root_path, alert: 'You must be logged in to do that.'
  end

  def current_user
    Current.user ||= authenticate_user_from_session
  end
  helper_method :current_user

  def authenticate_user_from_session
    User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end
  helper_method :user_signed_in?

  def login(user)
    Current.user = user
    reset_session
    session[:user_id] = user.id
  end

  def logout(_user)
    Current.user = nil
    reset_session
  end
end
