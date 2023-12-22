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

  def google_oauth
    url = "https://www.googleapis.com/oauth2/v2/userinfo"                  
    response = HTTParty.get(url, headers: { "Authorization" => params[:access_token] })
                
    if @user = User.exists?(email: response.parsed_response["email"])
      @user = User.find_by(email: response.parsed_response["email"])
    else
      @user = User.create_user_for_google(response.parsed_response)      
    end
    token = JsonWebToken.encode(user_id: @user.id)    
    if @user
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
  
    return render_not_found_error unless user
  
    otp = generate_and_update_otp(user)
  
    if otp.present?
      send_otp_by_mail(user, otp)
      render json: { otp: otp }, status: :ok
    else
      render_otp_generation_error
    end
  end
  
  private

  def render_not_found_error
    render json: { error: 'User not found' }, status: :not_found
  end
  
  def render_otp_generation_error
    render json: { error: 'Failed to generate OTP' }, status: :unprocessable_entity
  end
  
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
