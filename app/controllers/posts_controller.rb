# frozen_string_literal: true

# Controller for managing blog posts
# Handles CRUD operations for posts and their publication status
class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_author, only: %i[edit update new create]
  before_action :check_post_visibility, only: [:show]

  def index
    # Zobrazí všetky publikované príspevky pre neprihlásených používateľov
    # alebo všetky príspevky pre admina a vlastné príspevky pre autorov
    @posts = if user_signed_in?
               if current_user.superadmin?
                 Post.all
               else
                 current_user.posts
               end
             else
               Post.published
             end
  end

  def show
    # @post is set by before_action :set_post
    # visibility check is handled by before_action :check_post_visibility
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      flash[:alert] = "Title can't be blank."
      render :new
    end
  end

  def edit
    return if current_user.superadmin? || (current_user.author? && @post.user == current_user)

    redirect_to root_path, alert: 'You are not authorized to edit this post.'
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @post.destroy
      redirect_to posts_url, notice: 'Post was successfully destroyed.'
    else
      redirect_to @post, alert: 'Failed to destroy the post.'
    end
  end

  private

  def set_post
    @post = Post.find_by(slug: params[:id]) || Post.find(params[:id])
  end

  def check_post_visibility
    return if @post.published || (user_signed_in? && current_user == @post.user)

    redirect_to root_path, alert: 'This post is not available.'
  end

  def post_params
    params.require(:post).permit(:title, :content, :user_id, :published)
  end

  def authorize_author
    return if current_user && (current_user.superadmin? || current_user.author?)

    redirect_to root_path, alert: 'You are not authorized to access this page.'
  end
end
