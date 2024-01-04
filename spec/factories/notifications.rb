# spec/factories/notifications.rb

FactoryBot.define do
  factory :notification do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    sent_at { Faker::Time.forward(days: 7) } # Sent at least 7 days into the future
  end
end
