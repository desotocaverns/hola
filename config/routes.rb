Rails.application.routes.draw do

  root 'sales#new'

  # Purchase routes

  resources :sales, param: :redemption_code, only: [:index, :new, :create, :edit, :show] do
    member do
      get :summarize, :successful
      delete :delete_purchase
      post :resend_email
    end
  end

  get '/sales/cart/:redemption_code' => 'sales#cart', as: 'cart'
  patch '/sales/update_cart' => 'sales#update_cart'

  patch '/sales/personal_info/:redemption_code' => 'sales#update_personal_info', as: 'update_personal_info'
  patch '/sales/edit_personal_info/:redemption_code' => 'sales#edit_personal_info', as: 'edit_personal_info'

  patch '/sales/checkout' => 'sales#checkout', as: 'checkout'
  patch '/sales/charge' => 'sales#charge'

  get '/sales/failure' => 'sales#failure', as: 'failure'

  post '/sales/:redemption_code/redeem' => 'sales#redeem', as: 'redeem'

  # Admin package and ticket routes

  resources :packages

  resources :tickets
  patch '/sales/change_priority/:id/:priority' => 'tickets#change_priority', as: 'change_priority'

  # Authentication

  devise_for :admins, :controllers => {:invitations => "admins/invitations"}

  devise_scope :admin do
    get '/login', to: 'devise/sessions#new'
  end

  as :admin do
    get 'admins/edit' => 'devise/registrations#edit', :as => 'edit_admin_registration'
    put 'admins' => 'devise/registrations#update', :as => 'admin_registration'
  end

  resources :admins, only: [:index, :destroy]

  # Mailer previews
  if Rails.env.development?
    mount CustomerMailerPreview => 'mail_view'
  end

end
