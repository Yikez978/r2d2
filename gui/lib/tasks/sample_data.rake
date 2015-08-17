namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Device.create!(mac: "00:1f:f3:cd:62:d2",
                 ip: "192.168.1.1")
    99.times do |n|
      mac  = Faker::Internet.mac_address
      ip = Faker::Internet.ip_v4_address
      Device.create!(mac: mac,
                   ip: ip)
    end
  end
end