# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  skip_before_action :verify_authenticity_token # Skip CSRF token verification for API
  respond_to :json

  def forgot
    return render json: { error: 'Email not present' } if params[:email].blank? # check if email is present

    user = User.find_by(email: params[:email]) # if present find user by email

    if user.present?
      user.send_reset_password_instructions
      render json: { status: 'ok' }, status: :ok
    else
      render json: { error: ['Email address not found. Please check and try again.'] }, status: :not_found
    end
  end

  def reset
    token = params[:token]&.to_s

    return render json: { error: 'Token not present' } unless token

    user = User.reset_password_by_token({
      reset_password_token: token,
      password: params[:password]
    })

    if user.present?
      render json: { message: 'password changed successfully' }, status: :ok
    else
      render json: { error: ['Link not valid or expired. Try generating a new link.'] }, status: :not_found
    end
  end
end