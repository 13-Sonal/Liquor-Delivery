require 'faker'
FactoryBot.define do
    factory :user do
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        contact_number { Faker::PhoneNumber.cell_phone_in_e164 }
        email_id { Faker::Internet.email }
        password { Faker::Internet.password }
    end
end