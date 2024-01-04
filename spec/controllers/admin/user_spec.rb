# spec/controllers/admin/users_controller_spec.rb

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin_user) { create(:admin_user) }
  let(:user) { create(:user, role: 'admin') }

  before do
    sign_in admin_user
  end

  describe 'GET #index' do
    it 'renders the users' do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: user.id }

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT #update' do
  it 'updates the user' do
    new_name = 'Updated Name'

    # Note: Params should be nested under the model name
    put :update, params: { id: user.id, user: { name: new_name } }

    expect(response).to have_http_status(:redirect)
    expect(user.reload.name).to eq(new_name)
  end
end
end
