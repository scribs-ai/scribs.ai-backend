# spec/models/content_spec.rb
require 'rails_helper'

RSpec.describe Content, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
  end
end
