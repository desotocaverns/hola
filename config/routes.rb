Rails.application.routes.draw do

  root 'sales#new'

  # Purchase routes

  get '/sales/failure' => 'sales#failure', as: 'failure'

  resources :sales, param: :redemption_code, only: [:index, :new, :create, :edit, :show] do
    member do
      get :summarize, :receipt
      delete :delete_purchase
      post :resend_email
    end
  end

  get "/privacy" => 'sales#privacy'

  get '/settings' => 'settings#edit'
  patch '/settings/update' => 'settings#update'

  get '/sales/cart/:redemption_code' => 'sales#cart', as: 'cart'
  patch '/sales/update_cart' => 'sales#update_cart'

  patch '/sales/personal_info/:redemption_code' => 'sales#update_personal_info', as: 'update_personal_info'
  patch '/sales/edit_personal_info/:redemption_code' => 'sales#edit_personal_info', as: 'edit_personal_info'

  patch '/sales/checkout' => 'sales#checkout', as: 'checkout'
  patch '/sales/charge' => 'sales#charge'

  post '/sales/:redemption_code/redeem' => 'sales#redeem', as: 'redeem'

  # Admin package and ticket routes

  resources :packages

  resources :tickets
  patch '/sales/change_priority/:id/:priority' => 'tickets#change_priority', as: 'change_priority'
  get '/not_for_sale/tickets' => 'tickets#nfs_index', as: 'nfs_index'

  # Authentication

  devise_for :admins, :controllers => {:invitations => "admins/invitations", :registrations => "admins/registrations"}

  devise_scope :admin do
    get '/login', to: 'devise/sessions#new'
  end

  as :admin do
    get 'admins/edit' => 'devise/registrations#edit', :as => 'edit_admin_registration'
    put 'admins' => 'admins/registrations#update', :as => 'admin_registration'
  end

  resources :admins, only: [:index, :destroy]

  # Mailer previews
  if Rails.env.development?
    mount CustomerMailerPreview => 'mail_view'
  end
end
