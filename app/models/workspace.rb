class Workspace < ApplicationRecord
	validates :name, presence: true
  has_many :team_members, dependent: :destroy
  has_one_attached :image

  def fetch_image_url
    return nil unless self.image.attached?

    if Rails.env.production?
      image_path = self.image.blob.url
    else
      image_path = Rails.application.routes.url_helpers.rails_blob_url(self.image, only_path: true) 
    end
  end
end
