Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json },
    controllers: { sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords',
      confirmations: 'users/confirmations'
    }

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
