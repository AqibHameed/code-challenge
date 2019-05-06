FactoryBot.define do
  factory :asset do
    address {Faker::Address.street_address}
    zipcode {Faker::Address.zip_code}
    city  {Faker::Address.city}
    is_restricted {Faker::Boolean.boolean}
    yoc  {1995}
    portfolio
  end
end
