# frozen_string_literal: true

# Controller for managing static pages
# Handles CRUD operations for pages and their publication status
class PagesController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]
  before_action :set_page, only: %i[show edit update destroy]
  before_action :authorize_author, only: %i[edit update new create]
  before_action :check_page_visibility, only: [:show]

  def index
    @pages = if user_signed_in?
               if current_user.superadmin?
                 Page.all
               else
                 current_user.pages
               end
             else
               Page.published
             end
  end

  def show
    return unless @page.is_blog_page

    @posts = Post.published.order(created_at: :desc)
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
    return if current_user.superadmin? || (current_user.author? && @page.user == current_user)

    redirect_to root_path, alert: 'You are not authorized to edit this page.'
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
    return if @page.published || (user_signed_in? && current_user == @page.user)

    redirect_to root_path, alert: 'This page is not available.'
  end

  def page_params
    params.require(:page).permit(:title, :content, :user_id, :published, :is_blog_page)
  end

  def authorize_author
    return if current_user && (current_user.superadmin? || current_user.author?)

    redirect_to root_path, alert: 'You are not authorized to access this page.'
  end
end
