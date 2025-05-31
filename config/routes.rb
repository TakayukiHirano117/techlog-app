Rails.application.routes.draw do
  resources :users, only: [:show]
  devise_for :users
  root 'home#top'

  resources :posts, only: [:index, :new, :create, :show, :destroy]
end
