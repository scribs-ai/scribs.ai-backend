class ApplicationController < ActionController::Base
	protect_from_forgery with: :null_session

  def token_info(user)
    token = JsonWebToken.encode(user_id: user.id)
    { token: token, exp: 1.day.from_now, id: user.id, email: user.email }
  end
end
