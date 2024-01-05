# spec/factories/workspace.rb

FactoryBot.define do
	factory :team_member do
		name { Faker::Name.name }
	end
end
  