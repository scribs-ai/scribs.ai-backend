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
  post 'subscriptions', to: 'subscriptions#create_subscription_and_invoice', as: 'create'

  devise_scope :user do
    post 'users/passwords/forgot' => "users/passwords#forgot"
    post 'users/passwords/reset' => "users/passwords#reset"
    get '/users/registrations/generate_otp', to: 'users/registrations#generate_otp'
    post '/users/registrations/google_oauth', to: 'users/registrations#google_oauth'
    post '/users/sessions/otp_login', to: 'users/sessions#otp_login'
  end

  namespace :settings do
    resources :user_profiles, only: [:show, :update]
    resource :user_analytics, only: [:show, :update, :destroy, :create]
    resource :accounts, only: [] do
      get :export_user_data
      delete 'delete_account', to: 'accounts#delete_account', as: 'delete_account'
    end
    resources :languages, only: [] do
      collection do
        get 'language_options'
        post 'set_language'
      end
    end
  end
end
