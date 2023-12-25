class Settings::UserProfilesController < ApplicationController
  before_action :authenticate_user, only: [:show, :update, :destroy]

  def show
    if @current_user
      render json: user_profile_json
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def update
    if @current_user
      if @current_user.update(user_params)
        render json: user_profile_json
      else
        render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def destroy
    if @current_user
      @current_user.destroy
      render json: { message: 'User deleted successfully' }, status: :no_content
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :profile_picture, :image)
  end

  def user_profile_json
    {
      id: @current_user.id,
      name: @current_user.name,
      email: @current_user.email,
      profile_picture: @current_user.image_url,
      created_at: @current_user.created_at,
      updated_at: @current_user.updated_at
    }
    
  end

  def authenticate_user
    token = request.headers["Authorization"]

    if token.nil?
      render json: { error: 'Authorization header is missing' }, status: :unauthorized
      return
    end

    begin
      decoded_token = JsonWebToken.decode(token)
      user_id = decoded_token["user_id"]
      @current_user = User.find_by(id: user_id)
      
      unless @current_user
        render json: { error: 'User not found' }, status: :unauthorized
      end
    rescue JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end
end
