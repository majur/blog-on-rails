# frozen_string_literal: true

# Controller for managing the site navigation menu
# Only superadmins can access and modify the menu
class MenuController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_superadmin
  before_action :set_pages, only: %i[index]
  before_action :set_page, only: %i[update reorder]

  def index
    @menu_items = Page.in_menu
  end

  def update
    handle_menu_toggle
    redirect_to menu_index_path
  end

  def reorder
    handle_position_change
    redirect_to menu_index_path
  end

  private

  def set_page
    @page = Page.find_by(slug: params[:id]) || Page.find(params[:id])
  end

  def set_pages
    @pages = Page.published.where(is_in_menu: false)
  end

  def menu_params
    params.require(:page).permit(:is_in_menu)
  end

  def authorize_superadmin
    return if current_user.superadmin?

    flash[:alert] = 'Superadmin permission is required to access this page.'
    redirect_to root_path
  end

  def handle_menu_toggle
    if menu_params[:is_in_menu] == '1' && !@page.is_in_menu?
      add_to_menu
    elsif menu_params[:is_in_menu] == '0' && @page.is_in_menu?
      remove_from_menu
    end
  end

  def add_to_menu
    @page.update(is_in_menu: true)
    flash[:notice] = "Page '#{@page.title}' has been added to the menu."
  end

  def remove_from_menu
    @page.update(is_in_menu: false)
    flash[:notice] = "Page '#{@page.title}' has been removed from the menu."
  end

  def handle_position_change
    case params[:direction]
    when 'up'
      move_item_up
    when 'down'
      move_item_down
    when 'top'
      move_item_to_top
    when 'bottom'
      move_item_to_bottom
    end
  end

  def move_item_up
    @page.move_higher
    flash[:notice] = "Item '#{@page.title}' has been moved up."
  end

  def move_item_down
    @page.move_lower
    flash[:notice] = "Item '#{@page.title}' has been moved down."
  end

  def move_item_to_top
    @page.move_to_top
    flash[:notice] = "Item '#{@page.title}' has been moved to the top."
  end

  def move_item_to_bottom
    @page.move_to_bottom
    flash[:notice] = "Item '#{@page.title}' has been moved to the bottom."
  end
end
