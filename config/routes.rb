Rails.application.routes.draw do

  root 'sales#new'

  # Purchase routes

  resources :sales, only: [:index, :new, :create, :show]

  get '/sales/summary/:token' => 'sales#summary', as: 'summary'
  patch '/sales/personal_info/:token' => 'sales#update_personal_info', as: 'update_personal_info'
  patch '/sales/update_cart' => 'sales#update_cart'
  patch '/sales/checkout' => 'sales#checkout', as: 'checkout'
  patch '/sales/charge' => 'sales#charge'

  get '/sales/:token/success' => 'sales#success', as: 'success'

  get '/sales/failure' => 'sales#failure', as: 'failure'

  post '/sales/:redemption_code/redeem' => 'sales#redeem', as: 'redeem'

  # Admin package and ticket routes

  resources :packages

  resources :tickets

  # Authentication

  devise_for :admins, :controllers => {:invitations => "admins/invitations"}

  resources :admins, only: [:index, :destroy]

end
