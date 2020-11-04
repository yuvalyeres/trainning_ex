Rails.application.routes.draw do
  resources :users, only: [:index, :show, :create]

  root 'users#index'
end
