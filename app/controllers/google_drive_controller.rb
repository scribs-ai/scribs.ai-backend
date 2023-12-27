class GoogleDriveController < ApplicationController
  
  before_action :authenticate_user

  def upload_file
    file = params[:file]

    if file.present? && file.respond_to?(:tempfile)
      response = GoogleDriveService.call(file)
      render json: {message: "File uploaded sucessfully"}, status: :ok
    else
      render json: { message: "Unable to upload! Try again"}, status: :unprocessable_entity
    end
  end
end