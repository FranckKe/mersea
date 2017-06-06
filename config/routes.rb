Rails.application.routes.draw do
  devise_for :admin
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # devise_for :users
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  match '/status', to: 'application#status', via: %i(get head)
  root to: 'pages#index'
  resources :tracers, only: [:index, :show]
  resources :reports, only: [:index, :create, :new]
  resources :pages, only: [:show, :index]

  resources :users, only: [:get, :patch] do
    collection do
      get 'me'
      patch 'me'
      get 'reports'
      put 'update_password', defaults: { format: 'json' }, to: 'users#update_password'
    end
  end
  match '/leaderboard', to: 'pages#leaderboard', via: :get
end
