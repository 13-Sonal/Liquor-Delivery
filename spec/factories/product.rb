require 'faker'
FactoryBot.define do
    factory :product do
        name { Faker::Name.first_name }
    end
end