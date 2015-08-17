Rails.application.routes.draw do

  root 'purchases#new'

  # Purchase routes

  resources :purchases, only: [:index, :new, :create, :show]

  patch '/purchases/update_quantities' => 'purchases#update_quantities', 'as' => 'update_purchase_quantities'
  patch '/purchases/update_personal_info' => 'purchases#update_personal_info'
  patch '/purchases/charge' => 'purchases#charge'

  get '/purchases/:redemption_id/success' => 'purchases#success', as: 'success'

  get '/purchases/failure' => 'purchases#failure', as: 'failure'

  post '/purchases/:redemption_id/redeem' => 'purchases#redeem', as: 'redeem'

  # Admin package routes

  resources :packages

  # Authentication

  devise_for :admins, :controllers => {:invitations => "admins/invitations"}

  resources :admins, only: [:index, :destroy]

end
