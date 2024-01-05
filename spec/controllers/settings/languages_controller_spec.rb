# spec/controllers/settings/languages_controller_spec.rb

require 'rails_helper'

RSpec.describe Settings::LanguagesController, type: :controller do
  describe 'GET #language_options' do
    it 'returns a success response with available languages' do
      get :language_options
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      json_response = JSON.parse(response.body)
      expect(json_response).to have_key('languages')
      expect(json_response['languages']).to be_an(Array)
    end
  end

  describe 'POST #set_language' do
    let(:valid_locale) { 'en' }
    let(:invalid_locale) { 'invalid_locale' }

    it 'sets the language to the specified locale' do
      post :set_language, params: { locale: valid_locale }
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('success')
      expect(json_response['message']).to eq("Language set to #{valid_locale}")
      expect(I18n.locale.to_s).to eq(valid_locale)
    end

    it 'returns an error for an invalid language selection' do
      post :set_language, params: { locale: invalid_locale }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('error')
      expect(json_response['message']).to eq('Invalid language selection')
      # Make sure I18n.locale is not changed for an invalid selection
      expect(I18n.locale).to_not eq(invalid_locale.to_sym)
    end
  end
end
