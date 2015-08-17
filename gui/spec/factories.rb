FactoryGirl.define do
  factory :device do
    mac  Faker::Internet.mac_address
    ip   Faker::Internet.ip_v4_address
  end
end