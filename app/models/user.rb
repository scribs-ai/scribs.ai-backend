class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable
         has_one_time_password column: :otp_secret_key, length: 6

  def otp_generation(length = 6)
    characters = ('2'..'7').to_a
    secret = Array.new(length) { characters.sample }.join
  end
end
