# frozen_string_literal: true

# Controller for the main landing page of the application
# Handles rendering the home page and dashboard
class MainController < ApplicationController
  def index
    @posts = Post.published.order(created_at: :desc)
  end
end
