require 'netaddr'
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    #Rake::Task['db:reset'].invoke
    mask_array = (23..29).to_a
    25.times do
      cidr4 = NetAddr::CIDR.create(Faker::Internet.ip_v4_address+'/'+mask_array.sample.to_s)
      description = cidr4.to_s
      ip_array = cidr4.enumerate
      s = Sweep.create!(description: description)
      rand(cidr4.size-2).times do
        mac = Faker::Internet.mac_address
        ip = ip_array.sample
        s.devices.create!(mac: mac, ip: ip)
      end
    end
  end
end