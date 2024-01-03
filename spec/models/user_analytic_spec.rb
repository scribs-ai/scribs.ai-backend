# spec/models/user_analytic_spec.rb
require 'rails_helper'

RSpec.describe UserAnalytic, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'database indexes' do
    it { should have_db_index(:user_id) }
  end
end
