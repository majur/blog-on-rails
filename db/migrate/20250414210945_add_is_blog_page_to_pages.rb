class AddIsBlogPageToPages < ActiveRecord::Migration[8.0]
  def change
    add_column :pages, :is_blog_page, :boolean
  end
end
