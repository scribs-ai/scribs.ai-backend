# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_one_attached(:image) }
    it { should have_one(:user_analytic).dependent(:destroy) }
  end

  describe 'devise configurations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password).on(:create) }
    it { should validate_length_of(:password).is_at_least(Devise.password_length.min).on(:create) }
    it { should validate_length_of(:password).is_at_most(Devise.password_length.max).on(:create) }
    it { should validate_confirmation_of(:password) }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('user@').for(:email) }
  end
end
