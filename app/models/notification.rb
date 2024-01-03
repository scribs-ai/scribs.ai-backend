class Notification < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "id_value", "sent_at", "title", "updated_at"]
  end
end
