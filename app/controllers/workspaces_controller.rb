class WorkspacesController < ApplicationController
  require 'aws-sdk-s3'

  before_action :set_workspace, only: [:show, :update, :destroy]

  def index
    @workspaces = Workspace.all
    render json: @workspaces
  end

  def show
    render json: @workspace
  end

  def create
    @workspace = Workspace.new(workspace_params)
    if @workspace.save
      s3_client = get_s3_client
      directory = create_directory(s3_client)

      render json: @workspace, status: :created
    else
      render json: @workspace.errors, status: :unprocessable_entity
    end
  end

  def update
    if @workspace.update(workspace_params)
      render json: @workspace
    else
      render json: @workspace.errors, status: :unprocessable_entity
    end
  end

  def destroy
		if @workspace
			@workspace.destroy
			render json: { message: 'Workspace successfully deleted' }
		else
			render json: { error: 'Workspace not found' }
		end
	end

  private

  def set_workspace
		@workspace = Workspace.find_by(id: params[:id])
	
		unless @workspace
			render json: { error: 'Workspace not found' }, status: :not_found
		end
	end
	
  def workspace_params
    params.require(:workspace).permit(:name, :archived)
  end

  def get_s3_client
    s3 = Aws::S3::Client.new(
    access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
    secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
    region: Rails.application.credentials.dig(:aws, :region)
  )
  end

  def create_directory(s3_client)
    directory_name = @workspace.name
    bucket_name = Rails.application.credentials.dig(:aws, :bucket)
    directory_key = "#{directory_name}/"

    head_object_response = s3_client.head_object(
      bucket: bucket_name,
      key: directory_key
    )

    return Aws::S3::Object.new(bucket_name, directory_key) if head_object_response

    s3_client.put_object(
      bucket: bucket_name,
      key: directory_key
    )

    Aws::S3::Object.new(bucket_name, directory_key)
  end
end
