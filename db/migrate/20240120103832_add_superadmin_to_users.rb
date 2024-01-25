class AddSuperadminToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :superadmin, :boolean
  end
end
