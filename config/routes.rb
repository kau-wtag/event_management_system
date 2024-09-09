require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  
  namespace :admin do
    get 'dashboard/index'
    resources :events
    resources :users, only: [:index, :show, :destroy]
    resources :categories
  end
  root "events#index"

  resource :session, only: [:new, :create, :destroy]

  resources :users
  get 'signup', to: 'users#new'

  resources :events do
    resources :registrations
  end

  get 'verify_email', to: 'email_verifications#verify', as: 'verify_email'

  resources :password_resets, only: [:new, :create]
  get 'password_resets/:token/edit', to: 'password_resets#edit', as: 'edit_password_reset'
  patch 'password_resets/:token', to: 'password_resets#update', as: 'password_reset'
end
