# frozen_string_literal: true

class AddBlogNameToSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :settings, :blog_name, :string
  end
end
