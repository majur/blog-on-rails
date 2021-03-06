Rails.application.routes.draw do
  get     '/login',   to: 'sessions#new'
  post    '/signup',  to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'
  delete  '/users',   to: 'users#destroy'
  get     '/logout',  to: 'sessions#new'
  get     '/signup',  to: 'users#new'
  resources :posts
  resources :users
  resources :pages
  resources :settings
  root 'blog#blog'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
