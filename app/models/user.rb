class User < ApplicationRecord
  has_one_attached :image
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  serialize :notification_preferences, type: Hash, coder: YAML

  def otp_generation(length = 6)
    characters = ('2'..'7').to_a
    secret = Array.new(length) { characters.sample }.join
  end

  def self.create_user_for_google(data)
    where(email: data["email"]).first_or_initialize.tap do |user|
      user.email=data["email"]
      user.password=Devise.friendly_token[0,20]
      user.password_confirmation=user.password
      user.save!
    end
  end

  def image_url
    if Rails.env.production?
      image_url = self.image.blob.url
    else
      image_url = Rails.application.routes.url_helpers.rails_blob_url(self.image, only_path: true) 
    end
    image_url
  end
end
