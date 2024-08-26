Rails.application.routes.draw do
  root "events#index"

  resource :session, only: [:new, :create, :destroy]

  resources :users
  get 'signup', to: 'users#new'


  resources :events
end
