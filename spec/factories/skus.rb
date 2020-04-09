FactoryBot.define do
  factory :sku do
    spec { Faker::Name.name }
    quantity { Faker::Number.between(1, 10) }
    
    product
  end
end
