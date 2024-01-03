class Content < ApplicationRecord
  
  def self.ransackable_attributes(auth_object = nil)
    ["body", "created_at", "id", "id_value", "image_url", "published_at", "title", "updated_at"]
  end
end
