Rails.application.routes.draw do
  devise_for :admin

  match '/status', to: 'application#status', via: %i(get head)
  root to: 'pages#index'
  resources :tracers, only: [:index, :show]
  resources :reports, only: [:index, :create, :new]
  resources :pages, only: [:show, :index]

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
