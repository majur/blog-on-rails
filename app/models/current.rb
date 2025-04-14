# frozen_string_literal: true

# Current provides a per-request global storage using thread locals
# Used for storing the current user throughout a request
class Current < ActiveSupport::CurrentAttributes
  attribute :user
end
