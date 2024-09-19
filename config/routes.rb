require 'sidekiq/web'

Rails.application.routes.draw do
  # Mount Sidekiq Web interface
  mount Sidekiq::Web => '/sidekiq'

  # Localized routing for multilingual support
  scope "(:locale)", locale: /en|es/ do
    # Admin namespace for admin-specific routes
    namespace :admin do
      get 'dashboard/index'
      resources :events, only:[:index, :show]
      resources :users, only: [:index, :show, :destroy]
      resources :categories, only: [:new, :index, :edit, :create, :destroy]
    end

    # Organizer namespace for organizer-specific routes
    namespace :organizer do
      get 'dashboard/index'
      get 'events/upcoming', to: 'events#upcoming', as: 'upcoming_events'
      resources :events # Routes like /organizer/events
    end

    # Root route for events listing
    root "events#index"
    
    # Session management (login/logout)
    resource :session, only: [:new, :create, :destroy]

    # Users routes for profile management
    resources :users do
      member do
        delete :delete_avatar
      end
    end
    get 'signup', to: 'users#new'
    get 'signup/user', to: 'users#new_user', as: 'signup_user'
    get 'signup/organizer', to: 'users#new_organizer', as: 'signup_organizer'
    post 'signup/user', to: 'users#create_user'
    post 'signup/organizer', to: 'users#create_organizer'
    
    # Main events routes for users and general visitors
    resources :events do
      resources :registrations
      resources :comments, only: [:create, :destroy]
      resource :like, only: [:create, :destroy]
      resource :favorite, only: [:create, :destroy]
      resources :ratings, only: [:new, :create, :edit, :update, :destroy]
      resource :follow, only: [:create, :destroy]
    end
    
    # Email verification route
    get 'verify_email', to: 'email_verifications#verify', as: 'verify_email'
    
    # Password reset routes
    resources :password_resets, only: [:new, :create]
    get 'password_resets/:token/edit', to: 'password_resets#edit', as: 'edit_password_reset'
    patch 'password_resets/:token', to: 'password_resets#update', as: 'password_reset'
  end
end
