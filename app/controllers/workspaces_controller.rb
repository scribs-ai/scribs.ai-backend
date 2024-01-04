class WorkspacesController < ApplicationController
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
end
