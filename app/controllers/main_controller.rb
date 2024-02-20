class MainController < ApplicationController
  def index
    @posts = Post.published.order(created_at: :desc)
  end
end
