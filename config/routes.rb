Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, defaults: { format: :json },
    controllers: { sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords',
      confirmations: 'users/confirmations'
    }

  post 'google_drive/upload_file', to: 'google_drive#upload_file', as: 'upload_file'
  patch 'subscription/upgrade', to: 'subscriptions#upgrade', as: 'upgrade'
  delete 'subscription/cancel', to: 'subscriptions#cancel', as: 'cancel'
  post 'customer_intent', to: 'subscriptions#create_customer_and_intent', as: 'customer_intent'
  get 'refunds', to: 'subscriptions#refunds', as: 'refunds'
  
  post '/stripe-webhooks', to: 'stripe_webhooks#handle_event'

  devise_scope :user do
    post 'users/passwords/forgot' => "users/passwords#forgot"
    post 'users/passwords/reset' => "users/passwords#reset"
    get '/users/registrations/generate_otp', to: 'users/registrations#generate_otp'
    post '/users/registrations/google_oauth', to: 'users/registrations#google_oauth'
    post '/users/sessions/otp_login', to: 'users/sessions#otp_login'
  end
  
  resources :workspaces do
    resources :team_members
    post 'upload_workspace_data_s3'
    get 'fetch_workspace_data' 
  end

  namespace :settings do
    resources :user_profiles, only: [:show, :update]
    resource :user_analytics, only: [:show, :update, :destroy, :create]
    resource :accounts, only: [] do
      get :export_user_data
      delete 'delete_account', to: 'accounts#delete_account', as: 'delete_account'
      post 'two_factor_setting', to: 'accounts#two_factor_setting', as: 'two_factor_setting'
    end
    resources :languages, only: [] do
      collection do
        get 'language_options'
        post 'set_language'
      end
    end
  end
end
