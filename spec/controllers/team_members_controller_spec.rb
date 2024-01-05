# spec/controllers/team_members_controller_spec.rb

require 'rails_helper'

RSpec.describe TeamMembersController, type: :controller do
  let(:workspace) { create(:workspace) }
  let(:team_member) { create(:team_member, workspace: workspace) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: { workspace_id: workspace.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { workspace_id: workspace.id, id: team_member.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new TeamMember' do
        expect {
          post :create, params: { workspace_id: workspace.id, team_member: attributes_for(:team_member) }
        }.to change(TeamMember, :count).by(1)
      end

      it 'renders a JSON response with the new team member' do
        post :create, params: { workspace_id: workspace.id, team_member: attributes_for(:team_member) }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new team member' do
        post :create, params: { workspace_id: workspace.id, team_member: attributes_for(:team_member, name: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested team member' do
        put :update, params: { workspace_id: workspace.id, id: team_member.id, team_member: { name: 'New Name' } }
        team_member.reload
        expect(team_member.name).to eq('New Name')
      end

      it 'renders a JSON response with the updated team member' do
        put :update, params: { workspace_id: workspace.id, id: team_member.id, team_member: { name: 'New Name' } }
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the team member' do
        put :update, params: { workspace_id: workspace.id, id: team_member.id, team_member: { name: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested team member' do
      team_member # Ensure team member exists
      expect {
        delete :destroy, params: { workspace_id: workspace.id, id: team_member.to_param }
      }.to change(TeamMember, :count).by(-1)
    end

    it 'renders a JSON response with a success message' do
      delete :destroy, params: { workspace_id: workspace.id, id: team_member.id }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response.body).to include('Team member successfully deleted')
    end
  end
end
