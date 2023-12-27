class Settings::UserProfilesController < ApplicationController
  before_action :authenticate_user, only: [:show, :update]

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

  private
  def user_params
    params.require(:user).permit(:name, :image)
  end

  def user_profile_json
    {
      id: @current_user.id,
      name: @current_user.name,
      email: @current_user.email,
      profile_picture: @current_user.fetch_image_url,
      created_at: @current_user.created_at,
      updated_at: @current_user.updated_at
    }
  end
  
end
