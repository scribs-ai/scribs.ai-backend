FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' } # Change to your desired password
    password_confirmation { 'password123' }
    name { Faker::Name.name }
    role { 'user' }
    # Add more attributes as needed
  end
end
