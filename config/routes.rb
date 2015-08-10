Rails.application.routes.draw do

  root 'purchase#index'

  # Purchase routes

  resources :purchase, only: [:create, :new, :show]

  match '/purchase/new', :to => 'purchase#index', via: [:get]
  match '/purchase/create', :to => 'purchase#charge', :as => :charge_purchase, via: [:post]

  get '/purchase/success/:redemption_id' => 'purchase#success'
  post '/purchase/:id/redeem' => 'purchase#redeem'

  # Admin package routes

  resources :packages

  # Authentication

  devise_for :admins

  resources :admins, only: [:index, :edit, :destroy, :new, :create]

end
