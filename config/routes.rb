# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")

  resource :registration
  resource :session
  resource :password_reset
  resource :password
  resource :user_settings
  resource :setting
  resources :users
  resources :posts
  resources :pages

  # Menu management routes
  resources :menu, only: %i[index update] do
    patch :reorder, on: :member
  end

  root 'main#index'
end
