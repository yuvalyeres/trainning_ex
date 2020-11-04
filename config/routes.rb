Rails.application.routes.draw do
  resources :users, only: [:index, :show, :create, :update]
  post 'sign_in', to: 'users#sign_in'
  post 'sign_out', to: 'users#sign_out'

  root 'users#index'
end
