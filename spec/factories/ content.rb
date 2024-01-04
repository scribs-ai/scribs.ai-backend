# spec/factories/contents.rb

FactoryBot.define do
  factory :content do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
  end
end
