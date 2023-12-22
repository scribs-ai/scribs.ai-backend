# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  def show
    user = resource_class.confirm_by_token(params[:confirmation_token])
    if user.errors.empty?
      render json: token_info(user), status: :ok
    else
      render json: { errors: user.errors.messages}
    end
  end
end
