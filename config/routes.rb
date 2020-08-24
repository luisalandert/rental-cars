Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'
  resources :car_categories, only: [:index, :show, :new, :create]
  resources :subsidiaries, only: [:index, :show]
  resources :car_models, only: [:index, :show, :new, :create]
  resources :rentals, only: [:index, :show, :new, :create]
end
