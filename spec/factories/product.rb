require 'faker'
FactoryBot.define do
  factory :product do
    name { Faker::Name.first_name }
    stock { Faker::Base.numerify('##') }
    price { Faker::Base.numerify('###') }
  end
end
