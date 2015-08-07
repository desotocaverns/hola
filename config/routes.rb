Rails.application.routes.draw do

  # Purchase routes

  root 'purchase#index'

  resources :purchase, only: [:create, :new]

  match '/purchase/new', :to => 'purchase#index', via: [:get]
  match '/purchase/create', :to => 'purchase#charge', :as => :charge_purchase, via: [:post]

  get '/purchase/success/:id/:name' => 'purchase#success'

  # Admin package routes

  resources :packages

end
