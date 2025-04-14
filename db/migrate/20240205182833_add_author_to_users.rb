# frozen_string_literal: true

class AddAuthorToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :author, :boolean, default: false
  end
end
