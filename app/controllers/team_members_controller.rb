class TeamMembersController < ApplicationController
	before_action :set_workspace
  before_action :set_team_member, only: [:show, :update, :destroy]

  def index
    @team_members = @workspace.team_members
    render json: @team_members
  end

  def show
    render json: @team_member
  end

	def create
		@team_member = @workspace.team_members.new(team_member_params)
		if @team_member.save
			render json: { message: 'Team member successfully created', team_member: @team_member }, status: :created
		else
			render json: @team_member.errors, status: :unprocessable_entity
		end
	end
	
  def update
		if @team_member.update(team_member_params)
			render json: { message: 'Team member successfully updated', team_member: @team_member }
		else
			render json: @team_member.errors, status: :unprocessable_entity
		end
	end

  def destroy
		if @team_member
			@team_member.destroy
			render json: { message: 'Team member successfully deleted' }
		else
			render json: { error: 'Team member not found' }
		end
	end

  private

	def set_workspace
		@workspace = Workspace.find_by(id: params[:workspace_id])
	
		unless @workspace
			render json: { error: 'Workspace not found' }, status: :not_found
		end
	end

  def set_team_member
		@team_member = @workspace.team_members.find_by(id: params[:id])
	
		unless @team_member
			render json: { error: 'Team member not found' }, status: :not_found
		end
	end

  def team_member_params
    params.require(:team_member).permit(:name, :role)
  end
end
