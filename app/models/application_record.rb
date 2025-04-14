# frozen_string_literal: true

# Base model class that all application models inherit from
# Provides common functionality shared across model classes
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
