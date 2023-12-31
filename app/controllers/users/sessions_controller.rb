
# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  before_action :authorize_request, except: [:create, :otp_login]

  def create
    user = User.find_by_email(params[:user][:email])
    return render_user_not_found unless user
    return render_unauthorized unless user.confirmed_at

    if user&.valid_password?(params[:user][:password])
      render json: token_info(user), status: :ok
    else
      render json: { error: 'Email is Invalid' }, status: 401
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
  
  private
  
  def render_unauthorized
    render json: { message: 'Please confirm email' }, status: :unauthorized
  end

  def render_user_not_found
    render json: { message: 'User not found' }, status: :unauthorized
  end
end
