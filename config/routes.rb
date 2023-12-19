Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json },
    controllers: { sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }

  devise_scope :user do
    post 'users/passwords/forgot' => "users/passwords#forgot"
    post 'users/passwords/reset' => "users/passwords#reset"
  end
end
