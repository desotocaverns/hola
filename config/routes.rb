Rails.application.routes.draw do

  root 'purchase#new'

  # Purchase routes

  resources :purchase, only: [:index, :create, :new, :show]

  get '/purchase/success/:redemption_id' => 'purchase#success'
  post '/purchase/:id/redeem' => 'purchase#redeem'

  # Admin package routes

  resources :packages

  # Authentication

  devise_for :admins, :controllers => {:invitations => "admins/invitations"}

  resources :admins, only: [:index, :destroy]

end
