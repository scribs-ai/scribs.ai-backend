# spec/admin/content_spec.rb
require 'rails_helper'

RSpec.describe Admin::ContentsController, type: :controller do
  let(:admin_user) { AdminUser.create(email: 'admin@example.com', password: 'password123') }
  let(:content) { Content.create(title: 'New year promotion') }

  before do
    admin_user # Ensure admin_user is created before logging in
    sign_in admin_user
  end

  it 'returns a status of 200 for the index action' do
    get :index
    expect(response).to have_http_status(:ok)
  end

  it 'returns a status of 200 for the show action' do
    get :show, params: { id: content.id }
    expect(response).to have_http_status(:ok)
  end

  it 'returns a status of 200 for the edit action' do
    get :edit, params: { id: content.id }
    expect(response).to have_http_status(:ok)
  end

  it 'creates a new Content and redirects to the index' do
    post :create, params: { content: { title: 'New Content', body: 'Some text', published_at: Time.now } }
    expect(response).to have_http_status(:found) # :found is equivalent to :302
  end

  it 'updates the Content and redirects to the index' do
    patch :update, params: { id: content.id, content: { title: 'Updated Content' } }
    expect(response).to have_http_status(:found) # :found is equivalent to :302
  end

  it 'destroys the Content and redirects to the index' do
    delete :destroy, params: { id: content.id }
    expect(response).to have_http_status(:found) # :found is equivalent to :302
  end
end
