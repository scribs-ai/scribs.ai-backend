# spec/controllers/admin/dashboard_controller_spec.rb

require 'rails_helper'

RSpec.describe Admin::NotificationsController, type: :controller do
  let(:admin_user) { create(:admin_user) }
  let(:notification) { create(:notification) }
  before do
    sign_in admin_user
  end

  describe 'GET #index' do
    it 'renders the dashboard with correct content' do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end

  it 'sends email to all users' do
    post :send_email_all, params: { id: notification.id }

    expect(response).to redirect_to(admin_notifications_path)
    expect(flash[:notice]).to eq('Emails sent successfully to all users.')
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: notification.id }

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      get :edit, params: { id: notification.id }

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    it 'creates a new notification' do
      post :create, params: { notification: { title: 'New Notification', content: 'Lorem ipsum', sent_at: Time.now } }

      expect(flash[:notice]).to eq('Notification was successfully created.')
    end
  end

  describe 'PATCH #update' do
    it 'updates the notification' do
      patch :update, params: { id: notification.id, notification: { title: 'Updated Title' } }

      expect(flash[:notice]).to eq('Notification was successfully updated.')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the notification' do
      delete :destroy, params: { id: notification.id }

      expect(flash[:notice]).to eq('Notification was successfully destroyed.')
    end
  end

end
