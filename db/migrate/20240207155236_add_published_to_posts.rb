# frozen_string_literal: true

class AddPublishedToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :published, :boolean
  end
end
