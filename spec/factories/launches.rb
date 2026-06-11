FactoryBot.define do
  factory :launch do
    spacex_id { "MyString" }
    name { "MyString" }
    date_utc { "2026-06-09 22:25:50" }
    success { false }
    details { "MyText" }
    flight_number { 1 }
    raw_data { "" }
    rocket { nil }
    launchpad { nil }
  end
end
