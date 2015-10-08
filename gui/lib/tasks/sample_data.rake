namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Rake::Task['db:reset'].invoke
    25.times do
      description = Faker::Internet.domain_word
      s = Sweep.create!(description: description)
      rand(250).times do
        mac = Faker::Internet.mac_address
        ip = Faker::Internet.ip_v4_address
        s.devices.create!(mac: mac, ip: ip)
      end
    end
  end
end