# frozen_string_literal: true

class AddIsInMenuToPages < ActiveRecord::Migration[8.0]
  def change
    add_column :pages, :is_in_menu, :boolean, default: false
  end
end 