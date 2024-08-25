Rails.application.routes.draw do
  namespace :admin do
    get 'dashboard/index'
    resources :events
    resources :users, only: [:index, :show, :destroy]
  end
  root "events#index"

  resource :session, only: [:new, :create, :destroy]

  resources :users
  get 'signup', to: 'users#new'

  resources :events do
    resources :registrations
  end

  get 'verify_email', to: 'email_verifications#verify', as: 'verify_email'
end
