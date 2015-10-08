FactoryGirl.define do
  factory :device do
    mac  Faker::Internet.mac_address
    ip   Faker::Internet.ip_v4_address
  end
  factory :sweep do
    description Faker::Lorem.word
    transient do
      device_count 1
    end
    after(:create) do |sweep, evaluator|
#      create_list(:result, evaluator.device_count, sweep: sweep)
      evaluator.device_count.times  { sweep.devices << create(:device) }
    end
  end
end