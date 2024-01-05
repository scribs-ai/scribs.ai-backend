require 'csv'

class User < ApplicationRecord
  has_one_attached :image
  has_one :user_analytic, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  serialize :notification_preferences, type: Hash, coder: YAML

  # Default scope
  # ----------------------------------------------------------------------------
  default_scope { where(deleted: false) }

  def otp_generation(length = 6)
    characters = ('2'..'7').to_a
    secret = Array.new(length) { characters.sample }.join
  end


  def self.ransackable_attributes(auth_object = nil)
    ["confirmation_sent_at", "confirmation_token", "confirmed_at", "created_at", "deleted", "email", "encrypted_password", "id", "id_value", "first_name", "last_name", "notification_preferences", "otp_secret_key", "profile_picture", "remember_created_at", "reset_password_sent_at", "reset_password_token", "unconfirmed_email", "updated_at"]
  end


  def self.create_user_for_google(data)
    where(email: data["email"]).first_or_initialize.tap do |user|
      user.email=data["email"]
      user.password=Devise.friendly_token[0,20]
      user.password_confirmation=user.password
      user.save!
    end
  end

  def fetch_image_url
    return nil unless self.image.attached?

    if Rails.env.production?
      image_path = self.image.blob.url
    else
      image_path = Rails.application.routes.url_helpers.rails_blob_url(self.image, only_path: true) 
    end
  end

  def self.fetch_users_without_scope
    connection.select_all("SELECT first_name, last_name, email, notification_preferences,profile_picture, deleted FROM users").to_a
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |user|
        csv << user.attributes.values_at(*column_names)
      end
    end
  end
end
