# frozen_string_literal: true

class ModifySettingsTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :settings, :key
    remove_column :settings, :value
    add_column :settings, :registration_enabled, :boolean, default: false
  end
end
