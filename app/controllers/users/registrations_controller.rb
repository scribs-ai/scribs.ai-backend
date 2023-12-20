# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def create
    @user = User.new(sign_up_params)
    if @user.save
      render json: {
        id: @user.id, email: @user.email,
        token: JsonWebToken.encode(user_id: @user.id),
        message: 'Registration Successful!'
      }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def generate_otp
    user = User.find_by_email(params[:email])
    otp = generate_and_update_otp(user)
    send_otp_by_mail(user, otp)
    render json: { otp: otp }, status: :ok
  end
  
  private
  
  def generate_and_update_otp(user)
    otp = user.otp_generation
    user.update(otp_secret_key: otp)
    otp
  end
  
  def send_otp_by_mail(user, otp)
    UserMailer.otp_code_sent_by_mail(user).deliver_now
  end
  
  def sign_up_params
    params.permit(:email, :password, :password_confirmation)
  end  
end
