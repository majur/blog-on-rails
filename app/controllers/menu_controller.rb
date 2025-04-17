# frozen_string_literal: true

# Controller for managing the site navigation menu
# Only superadmins can access and modify the menu
class MenuController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_superadmin
  before_action :set_pages, only: %i[index]

  def index
    @menu_items = Page.in_menu
  end

  def update
    @page = Page.find_by(slug: params[:id]) || Page.find(params[:id])
    
    if menu_params[:is_in_menu] == '1' && !@page.is_in_menu?
      @page.update(is_in_menu: true)
      flash[:notice] = "Page '#{@page.title}' has been added to the menu."
    elsif menu_params[:is_in_menu] == '0' && @page.is_in_menu?
      @page.update(is_in_menu: false)
      flash[:notice] = "Page '#{@page.title}' has been removed from the menu."
    end

    redirect_to menu_index_path
  end

  def reorder
    @page = Page.find_by(slug: params[:id]) || Page.find(params[:id])
    
    case params[:direction]
    when 'up'
      @page.move_higher
      flash[:notice] = "Item '#{@page.title}' has been moved up."
    when 'down'
      @page.move_lower
      flash[:notice] = "Item '#{@page.title}' has been moved down."
    when 'top'
      @page.move_to_top
      flash[:notice] = "Item '#{@page.title}' has been moved to the top."
    when 'bottom'
      @page.move_to_bottom
      flash[:notice] = "Item '#{@page.title}' has been moved to the bottom."
    end

    redirect_to menu_index_path
  end

  private

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
end 