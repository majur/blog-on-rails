# frozen_string_literal: true

# User model representing application users.
# Manages authentication, permissions and relationships with other models.
class User < ApplicationRecord
  has_many :posts
  has_many :pages
  has_secure_password
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  normalizes :email, with: ->(email) { email.strip.downcase }

  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt&.last(10)
  end

  generates_token_for :email_confirmation, expires_in: 24.hours do
    email
  end

  attribute :author, :boolean, default: false
end
