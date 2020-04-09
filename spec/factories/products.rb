FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    list_price { Faker::Number.between(40, 50) }
    sell_price { Faker::Number.between(1, 40) }
    on_sell { false }

    vendor
    category

    trait :with_skus do
      transient do
        amount { 3}
      end
      skus { build_list :sku, amount }
    end
  end
end
