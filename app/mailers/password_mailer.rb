# frozen_string_literal: true

# Mailer responsible for sending password-related emails
# Handles password reset notifications
class PasswordMailer < ApplicationMailer
  def password_reset
    mail to: params[:user].email
  end
end
