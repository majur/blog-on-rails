# frozen_string_literal: true

class AddPositionToPages < ActiveRecord::Migration[8.0]
  def change
    add_column :pages, :position, :integer
    add_index :pages, :position
  end
end 