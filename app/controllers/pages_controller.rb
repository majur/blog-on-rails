class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :authorize_author, only: [:edit, :update, :new, :create, :index]
  before_action :check_page_visibility, only: [:show]

  def index
    if current_user.superadmin?
      @pages = Page.all
    else
      @pages = current_user.pages
    end
  end

  def show
    # @page is set by before_action :set_page
    # visibility check is handled by before_action :check_page_visibility
  end

  def new
    @page = Page.new
  end

  def create
    @page = current_user.pages.new(page_params)

    if @page.save
      redirect_to @page, notice: 'Page was successfully created.'
    else
      flash[:alert] = "Title can't be blank."
      render :new
    end
  end

  def edit
    unless current_user.superadmin? || (current_user.author? && @page.user == current_user)
      redirect_to root_path, alert: 'You are not authorized to edit this page.'
    end
  end

  def update
    if @page.update(page_params)
      redirect_to @page, notice: 'Page was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @page.destroy
      redirect_to pages_url, notice: 'Page was successfully destroyed.'
    else
      redirect_to @page, alert: 'Failed to destroy the page.'
    end
  end

  private

  def set_page
    @page = Page.find_by(slug: params[:id]) || Page.find(params[:id])
  end

  def check_page_visibility
    unless @page.published || (user_signed_in? && current_user == @page.user)
      redirect_to root_path, alert: "This page is not available."
    end
  end

  def page_params
    params.require(:page).permit(:title, :content, :user_id, :published)
  end

  def authorize_author
    unless current_user && (current_user.superadmin? || current_user.author?)
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end
end
