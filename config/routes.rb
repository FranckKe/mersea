Rails.application.routes.draw do
  devise_for :admin

  root to: 'pages#index'
  resources :tracers, only: [:index, :show]
  resources :reports, only: [:index, :show, :create, :new]
  resources :pages, only: [:show, :index]

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
