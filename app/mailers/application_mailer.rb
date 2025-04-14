# frozen_string_literal: true

# Base mailer class that all application mailers inherit from
# Sets up default sender and layout template for all emails
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
