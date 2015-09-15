Rails.application.routes.draw do

  root 'sales#new'

  # Purchase routes

  resources :sales, param: :redemption_code, only: [:index, :new, :create, :edit, :show] do
    member do
      get :summarize, :successful
      delete :delete_purchase
    end
  end

  patch '/sales/edit_personal_info/:redemption_code' => 'sales#edit_personal_info', as: 'edit_personal_info'
  patch '/sales/personal_info/:redemption_code' => 'sales#update_personal_info', as: 'update_personal_info'
  patch '/sales/update_cart' => 'sales#update_cart'
  patch '/sales/checkout' => 'sales#checkout', as: 'checkout'
  patch '/sales/charge' => 'sales#charge'
  
  get '/sales/cart/:redemption_code' => 'sales#cart', as: 'cart'

  get '/sales/failure' => 'sales#failure', as: 'failure'

  post '/sales/:redemption_code/redeem' => 'sales#redeem', as: 'redeem'

  # Admin package and ticket routes

  resources :packages

  resources :tickets

  # Authentication

  devise_for :admins, :controllers => {:invitations => "admins/invitations"}

  resources :admins, only: [:index, :destroy]

end
