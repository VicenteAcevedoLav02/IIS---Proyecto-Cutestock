Rails.application.routes.draw do
  get 'supplies/index'
  get 'supplies/new'
  get 'supplies/edit'
  get 'supplies/show'
  get 'products/index'
  get 'products/new'
  get 'products/edit'
  get 'products/show'
  get 'orders/index'
  get 'orders/new'
  get 'orders/edit'
  get 'orders/show'
  get 'home/index'
  resources :orders
  resources :products
  resources :supplies
  get 'orders/:id/progress_state', to: 'orders#progress_state', as: 'progress_order'

  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end
