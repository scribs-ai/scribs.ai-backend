class Settings::LanguagesController < ApplicationController
 skip_before_action :verify_authenticity_token

	def language_options
		render json: { languages: available_languages }
	end

	def set_language
		locale = params[:locale].to_sym.to_s
		if available_languages.include?(locale)
			I18n.locale = locale
			render json: { status: 'success', message: "Language set to #{locale}" }
		else
			render json: { status: 'error', message: 'Invalid language selection' }, status: :unprocessable_entity
		end
	end

	private

	def available_languages
		I18n.available_locales.map(&:to_s)
	end
end
