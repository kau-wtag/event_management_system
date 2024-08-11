Rails.application.routes.draw do
  root 'home#index'

  resource :session, only: [:new, :create, :destroy]

  resources :users
  get 'signup', to: 'users#new'

end
