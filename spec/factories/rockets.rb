FactoryBot.define do
  factory :rocket do
    spacex_id { "MyString" }
    name { "MyString" }
    description { "MyText" }
    first_flight { "2026-06-09" }
    active { false }
  end
end
