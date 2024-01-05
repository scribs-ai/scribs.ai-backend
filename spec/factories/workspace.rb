# spec/factories/workspace.rb

FactoryBot.define do
  factory :workspace do
    name { Faker::Name.name }
  end
end
