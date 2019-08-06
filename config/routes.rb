Rails.application.routes.draw do
  devise_for :admin
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
  match '/status', to: 'api#status', via: %i(get head)
  root to: 'pages#index'
  resources :tracers, only: %i(index show)
  resources :reports, only: %i(index create show update destroy)
  resources :pages, only: %i(index show)

  resources :users, only: %i(get patch) do
    collection do
      get 'me'
      patch 'me', to: 'users#update'
      patch 'update_password', to: 'users#update_password'
      delete 'me', to: 'users#destroy'
    end
  end
  match '/leaderboard', to: 'pages#leaderboard', via: :get

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
