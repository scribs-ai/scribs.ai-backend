# spec/models/notification_spec.rb
require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  describe 'scopes' do
    describe '.ransackable_attributes' do
      it 'returns the expected ransackable attributes' do
        ransackable_attributes = Notification.ransackable_attributes
        expected_attributes = ["content", "created_at", "id", "id_value", "sent_at", "title", "updated_at"]

        expect(ransackable_attributes).to eq(expected_attributes)
      end
    end
  end
end
