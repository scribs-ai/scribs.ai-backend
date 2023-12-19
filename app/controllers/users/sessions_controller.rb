# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :authorize_request, except: :create

  def create
    user = User.find_by_email(params[:user][:email])
    if user&.valid_password?(params[:user][:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, exp: 1.day.from_now, id: user.id, email: user.email }, status: :ok
    else
      render json: { error: 'bad request' }, status: 400
    end
  end
end
