require 'faker'
FactoryBot.define do
    factory :brand do
        name { Faker::Name.name }
        key { Faker::Name.name.downcase.parameterize(separator: '_') }
    end
end

Faker::Base.numerify('')