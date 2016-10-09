Rails.application.routes.draw do
  devise_for :admin

  root to: 'pages#index'
  resources :tracers, only: [:index, :show]
  resources :reports, only: [:index, :show, :create, :new]

  get '/security', to: 'pages#security'
  get '/about', to: 'pages#about'
  get '/links', to: 'pages#links'
  get '/ansel', to: 'pages#ansel'
  get '/disclaimer', to: 'pages#disclaimer'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
