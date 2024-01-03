class SystemConfiguration  < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "key", "updated_at", "value"]
  end
end
