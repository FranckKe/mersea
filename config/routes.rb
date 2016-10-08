Rails.application.routes.draw do
  devise_for :admin

  root to: 'pages#index'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
