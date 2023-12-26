class Settings::AccountsController < ApplicationController
	skip_before_action :verify_authenticity_token

	def export_user_data_to_csv
		users_data = User.all
		send_data User.to_csv,
                    filename: "user_data_#{Time.zone.now.strftime('%Y%m%d%H%M%S')}.csv",
                    type: 'text/csv; charset=utf-8',
                    disposition: 'attachment'
	end
end
  