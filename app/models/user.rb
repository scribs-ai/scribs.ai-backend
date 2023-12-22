class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  def otp_generation(length = 6)
    characters = ('2'..'7').to_a
    secret = Array.new(length) { characters.sample }.join
  end

  def self.create_user_for_google(data)
    where(email: data["email"]).first_or_initialize.tap do |user|
      user.provider="google_oauth2"
      user.email=data["email"]
      user.password=Devise.friendly_token[0,20]
      user.password_confirmation=user.password
      user.save!
    end
  end
end
