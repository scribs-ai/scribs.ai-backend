class WorkspacesController < ApplicationController
  require 'aws-sdk-s3'

  before_action :set_workspace, only: [:show, :update, :destroy]

  def index
    @workspaces = Workspace.all
    render json: @workspaces
  end

  def show
    @workspace = Workspace.find(params[:id])
    @workspace.image_url = @workspace.fetch_image_url
    render json: @workspace
  end

  def create
    @workspace = Workspace.new(workspace_params)
    if @workspace.save
      image_url =  @workspace.fetch_image_url
      @workspace.update(image_url: image_url)
      render json: {workspace: @workspace}, status: :created
    else
      render json: @workspace.errors, status: :unprocessable_entity
    end
  end

  def update
    if @workspace
      if @workspace.update(workspace_params)
        image_url =  @workspace.fetch_image_url
        @workspace.update(image_url: image_url)
        render json: {workspace: @workspace}, status: :ok
      else
        render json: { errors: @workspace.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Workspace not found' }, status: :not_found
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
    params.require(:workspace).permit(:name, :archived, :image)
  end

  def get_s3_client
    s3 = Aws::S3::Client.new(
    access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
    secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),
    region: Rails.application.credentials.dig(:aws, :region)
  )
  end

  def create_directory(s3_client, bucket_name)
    directory_name = @workspace.name
    directory_key = "#{directory_name}/"

    list_objects_response = s3_client.list_objects_v2( bucket: bucket_name, prefix: directory_key )
    
    if list_objects_response.contents.any?
      # Directory already exists, return the directory object
      return Aws::S3::Object.new(bucket_name, directory_key)
    end

    s3_client.put_object(
      bucket: bucket_name,
      key: "#{directory_key}"
    )

    Aws::S3::Object.new(bucket_name, directory_key)
  end
  
  def upload_file(s3_client, bucket_name)
    file_name = File.basename(workspace_params[:image].original_filename)
    file_path = workspace_params[:image].tempfile.path

    file_key = "#{@workspace.name}/#{file_name}"

    s3_client.put_object(
      bucket: bucket_name,
      key: file_key,
      body: File.open(file_path, 'rb')
    )
  end
  
end
