class Workspace < ApplicationRecord
	validates :name, presence: true
  has_many :team_members, dependent: :destroy
end
