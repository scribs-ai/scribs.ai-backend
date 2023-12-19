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

  private

  def sign_up_params
    params.permit(:email, :password, :password_confirmation)
  end  
end
