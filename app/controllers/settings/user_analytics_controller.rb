# app/controllers/api/v1/user_analytics_controller.rb
class Settings::UserAnalyticsController < ApplicationController
  before_action :authenticate_user

  def create
    if @current_user
      user_analytic = @current_user.create_user_analytic(user_analytics_params)
      render json: { data: user_analytic }, status: :created
    else
      render_user_not_found
    end
  end

  def show
    if @current_user && @current_user.user_analytic
      render json: { data: @current_user.user_analytic }
    else
      render_user_analytics_not_found
    end
  end

  def destroy
    if @current_user && @current_user.user_analytic
      @current_user.user_analytic.destroy
      render json: { message: 'User analytic deleted' }, status: :ok
    else
      render_user_analytics_not_found
    end
  end

  private
  def user_analytics_params
    params.permit(:time, :feature, :date, :tokens)
  end

  def render_user_not_found
    render json: { error: 'User not found' }, status: :not_found
  end

  def render_user_analytics_not_found
    render json: { error: 'User Analytics not found' }, status: :not_found
  end
end
