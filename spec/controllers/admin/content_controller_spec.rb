# spec/controllers/admin/contents_controller_spec.rb

require 'rails_helper'

RSpec.describe Admin::ContentsController, type: :controller do
  let(:admin_user) { create(:admin_user) }
  let(:content) { create(:content) }

  before do
    sign_in admin_user
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: content.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #edit' do
    it 'returns a successful response' do
      get :edit, params: { id: content.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    it 'creates a new Content and redirects to the index' do
      post :create, params: { content: { title: 'New Content', body: 'Some text', published_at: Time.now } }
      expect(response).to have_http_status(:found) # :found is equivalent to :302
    end
  end

  describe 'PATCH #update' do
    it 'updates the Content and redirects to the index' do
      patch :update, params: { id: content.id, content: { title: 'Updated Content' } }
      expect(response).to have_http_status(:found) # :found is equivalent to :302
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the Content and redirects to the index' do
      delete :destroy, params: { id: content.id }
      expect(response).to have_http_status(:found) # :found is equivalent to :302
    end
  end
end
