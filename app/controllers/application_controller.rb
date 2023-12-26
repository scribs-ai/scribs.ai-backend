class ApplicationController < ActionController::Base
	protect_from_forgery with: :null_session

  def token_info(user)
    token = JsonWebToken.encode(user_id: user.id)
    { token: token, exp: 1.day.from_now, id: user.id, email: user.email }
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
