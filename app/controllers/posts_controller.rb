class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_author, only: [:edit, :update, :new, :create, :index]

  def index
    if current_user.superadmin?
      @posts = Post.all
    else
      @posts = current_user.posts
    end
  end

  def show
    @post = Post.find(params[:id])
    if @post.published || (user_signed_in? && current_user == @post.user)
    else
      redirect_to root_path, alert: "This post is not available."
    end
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
    @post = Post.find(params[:id])
    unless current_user.superadmin? || (current_user.author? && @post.user == current_user)
      redirect_to root_path, alert: 'You are not authorized to edit this post.'
    end
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :user_id, :published)
  end

  def authorize_author
    unless current_user && (current_user.superadmin? || current_user.author?)
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end
end
