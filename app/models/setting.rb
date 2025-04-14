# frozen_string_literal: true

# Model for storing application-wide settings
# Contains configurations like blog name and registration status
class Setting < ApplicationRecord
  validates :blog_name, presence: true
end
