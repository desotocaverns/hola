Rails.application.routes.draw do

  root 'sales#new'

  # Purchase routes

  resources :sales, only: [:index, :new, :create, :show]

  patch '/sales/update_quantities' => 'sales#update_quantities', 'as' => 'update_sale_quantities'
  patch '/sales/update_personal_info' => 'sales#update_personal_info'
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
