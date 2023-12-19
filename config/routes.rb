Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json },
    controllers: { sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }

    # put "passwords/forgot", to: "user/passwords#forgot"
    
    # namespace :users do
    #   resources :passwords, only: [] do
    #     collection do
    #       put :forgot, :reset, format: :json
    #     end
    #   end
    # end

    # put "/user/passwords/forgot", to: "user/passwords#forgot"

    post 'social_auth/callback', to: 'users/social_auth#authenticate_social_auth_user'
end
