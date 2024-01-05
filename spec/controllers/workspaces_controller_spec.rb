# spec/controllers/workspaces_controller_spec.rb

require 'rails_helper'

RSpec.describe WorkspacesController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    let(:workspace) { create(:workspace) }

    it 'returns a success response' do
      get :show, params: { id: workspace.to_param }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Workspace' do
        expect {
          post :create, params: { workspace: attributes_for(:workspace) }
        }.to change(Workspace, :count).by(1)
      end

      it 'renders a JSON response with the new workspace' do
        post :create, params: { workspace: attributes_for(:workspace) }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new workspace' do
        post :create, params: { workspace: attributes_for(:workspace, name: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'PUT #update' do
    let(:workspace) { create(:workspace) }

    context 'with valid params' do
      it 'updates the requested workspace' do
        put :update, params: { id: workspace.to_param, workspace: { name: 'New Name' } }
        workspace.reload
        expect(workspace.name).to eq('New Name')
      end

      it 'renders a JSON response with the updated workspace' do
        put :update, params: { id: workspace.to_param, workspace: { name: 'New Name' } }
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the workspace' do
        put :update, params: { id: workspace.to_param, workspace: { name: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:workspace) { create(:workspace) }

    it 'destroys the requested workspace' do
      expect {
        delete :destroy, params: { id: workspace.to_param }
      }.to change(Workspace, :count).by(-1)
    end

    it 'renders a JSON response with a success message' do
      delete :destroy, params: { id: workspace.to_param }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(response.body).to include('Workspace successfully deleted')
    end
  end
end
