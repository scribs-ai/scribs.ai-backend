class Workspace < ApplicationRecord
	validates :name, presence: true
  has_many :team_members, dependent: :destroy
  has_one_attached :image
end
