# spec/controllers/admin/dashboard_controller_spec.rb

require 'rails_helper'

RSpec.describe Admin::NotificationsController, type: :controller do
  let(:admin_user) { create(:admin_user) }

  before do
    sign_in admin_user
  end

  describe 'GET #index' do
    it 'renders the dashboard with correct content' do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end
end
