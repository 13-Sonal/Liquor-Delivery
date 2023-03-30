require 'faker'
FactoryBot.define do
    factory :role do
        name { Faker::Name.name }
        key { Faker::Name.name.downcase.parameterize(separator: '_') }
    end
end