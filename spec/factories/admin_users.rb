
FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.email }
    password { 'password123' } # Change to your desired password
    password_confirmation { 'password123' }
  end
end
