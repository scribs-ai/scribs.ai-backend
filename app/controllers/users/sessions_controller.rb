
# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  before_action :authorize_request, except: :create

  def create
    user = User.find_by_email(params[:user][:email])
    if user&.valid_password?(params[:user][:password])
      token = JsonWebToken.encode(user_id: user.id)
      UserMailer.mail_sent(user).deliver_now
      render json: { token: token, exp: 1.day.from_now, id: user.id, email: user.email }, status: :ok
    else
      render json: { error: 'bad request' }, status: 400
    end
  end

  def otp_login
    user = User.find_by_email(params[:email])
    if user.otp_secret_key == params[:otp_secret]
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, exp: 1.day.from_now, id: user.id, email: user.email }, status: :ok
    else
      render json: { error: 'Invalid OTP' }, status: :unauthorized
    end
  end
end
