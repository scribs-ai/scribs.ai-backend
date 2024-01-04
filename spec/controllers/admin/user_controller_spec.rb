# spec/controllers/admin/users_controller_spec.rb

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin_user) { create(:admin_user) }

  before do
    sign_in admin_user
  end


  describe 'GET #index' do
    it 'renders the index page' do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end
