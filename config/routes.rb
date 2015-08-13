Rails.application.routes.draw do

  root 'purchases#new'

  # Purchase routes

  resources :purchases, only: [:index, :create, :new, :show]

  patch '/purchases/update_personal_info' => 'purchases#update_personal_info'
  patch '/purchases/charge' => 'purchases#charge'

  get '/purchases/:redemption_id/success' => 'purchases#success', as: 'success'

  post '/purchases/:redemption_id/redeem' => 'purchases#redeem', as: 'redeem'

  # Admin package routes

  resources :packages

  # Authentication

  devise_for :admins, :controllers => {:invitations => "admins/invitations"}

  resources :admins, only: [:index, :destroy]

end
