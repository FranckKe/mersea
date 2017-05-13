Rails.application.routes.draw do
  devise_for :users
  devise_for :admin

  match '/status', to: 'application#status', via: %i(get head)
  root to: 'pages#index'
  resources :tracers, only: [:index, :show]
  resources :reports, only: [:index, :create, :new]
  resources :pages, only: [:show, :index]

  resources :users, only: [:get, :patch] do
    collection do
      get 'me'
      patch 'me'
      patch 'update_password', defaults: { format: 'json' }
    end
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
