FactoryBot.define do
  factory :unit do
    size  {150}
    is_rented {true}
    rent  {500}
    unit_type  {Faker::Number.between(0, 2)}
    asset
  end
end
