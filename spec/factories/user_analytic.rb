# spec/factories/user_analytics.rb

FactoryBot.define do
	factory :user_analytic do
		association :user
		time { Faker::Time.backward(days: 7, period: :morning) }
		feature { Faker::Lorem.word }
		date { Faker::Date.backward(days: 7) }
		tokens { Faker::Number.between(from: 1, to: 10) }
	end
end
  