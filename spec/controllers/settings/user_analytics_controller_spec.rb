# spec/controllers/settings/user_analytics_controller_spec.rb

require 'rails_helper'

RSpec.describe Settings::UserAnalyticsController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_attributes) { { time: 'morning', feature: 'dashboard', date: '2022-01-01', tokens: 5 } }

  before { sign_in user }

  describe '#authenticate_user' do
    context 'when Authorization header is present and valid' do
      it 'sets @current_user' do
        token = JsonWebToken.encode(user_id: user.id)
        request.headers['Authorization'] = token
        controller.authenticate_user
        expect(assigns(:current_user)).to eq(user)
      end
    end
  end

  describe 'POST #create' do
    before { allow(controller).to receive(:authenticate_user) { controller.instance_variable_set(:@current_user, user) } }

    context 'with valid params' do
      it 'creates a new UserAnalytic' do
        expect {
          post :create, params: valid_attributes
        }.to change(UserAnalytic, :count).by(1)
      end

      it 'renders a JSON response with the new user analytic' do
        post :create, params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'when user is not found' do
      it 'renders a JSON response with an error message' do
        allow(controller).to receive(:authenticate_user) { controller.instance_variable_set(:@current_user, nil) }
        post :create, params: valid_attributes
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to include('User not found')
      end
    end
  end
end
