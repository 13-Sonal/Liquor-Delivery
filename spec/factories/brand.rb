require 'faker'
FactoryBot.define do
    factory :brand do
        name { Faker::Name.name }
    end
end

#Faker::Base.numerify('')