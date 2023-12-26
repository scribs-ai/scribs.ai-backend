class Settings::AccountsController < ApplicationController
	skip_before_action :verify_authenticity_token

	def export_user_data_to_csv
		users_data = User.all
		send_data User.to_csv,
                    filename: "user_data_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.csv",
                    type: 'text/csv; charset=utf-8',
                    disposition: 'attachment'
	end

	def delete_account
		user = User.find_by_email(params[:email])
		if user 
			user.update(deleted: true)
			render json: { message: 'User deleted successfully' }, status: :ok
		else
			render json: { error: 'User not found' }, status: :not_found
		end
  end 
end
  