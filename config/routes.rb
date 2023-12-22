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
end
