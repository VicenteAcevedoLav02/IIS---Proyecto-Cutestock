Rails.application.routes.draw do
  resources :orders do
    member do
      get 'progress_state', to: 'orders#progress_state', as: 'progress_order'
    end
  end

  resources :products
  resources :supplies
  resources :supplies do
    collection do
      get :needs_restock
    end
  end
  get 'home/index'
  get 'fees', to: 'home#index'
  get 'search', to: 'search#index'

  # Health check for load balancers and uptime monitors
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"

  # Devise routes for user authentication
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end
