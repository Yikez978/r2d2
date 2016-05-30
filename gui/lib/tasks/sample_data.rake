require 'netaddr'
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    #Rake::Task['db:reset'].invoke
    mask_array = (23..29).to_a
#    25.times do
#      cidr4 = NetAddr::CIDR.create(Faker::Internet.ip_v4_address+'/'+mask_array.sample.to_s)
#      description = cidr4.to_s
##      ip_array = cidr4.enumerate
#      s = Sweep.create!(description: description)
#      rand(cidr4.size-2).times do
#        mac = Faker::Internet.mac_address
#        s.devices.create!(mac: mac)
#      end
#    end
    2.times do
      ip = Faker::Internet.ip_v4_address
      name = Faker::Internet.domain_word + ".example.com"
      server = Server.create(ip: ip, name: name)
      10.times do
        mask = mask_array.sample.to_s
        cidr4 = NetAddr::CIDR.create(Faker::Internet.ip_v4_address+'/'+mask)
        ip_array = cidr4.enumerate
        server.scopes << Scope.create(ip: cidr4.network,
                                      mask: cidr4.wildcard_mask,
                                      description: Faker::Address.street_address,
                                      comment: Faker::Lorem.sentence(3))
        sweeper = Sweeper.create(ip: ip_array.sample,
                       description: cidr4.to_s,
                       mac: 6.times.map{ rand(256) }.map{ |d| '%02x' % d }.join(':').to_s)
        sweep = Sweep.create(description: cidr4.to_s)
        rand(cidr4.size-2).times do
          server.scopes.last.leases << Lease.create(ip: ip_array.sample,
                                                    device: Device.create(mac: 6.times.map{ rand(256) }.map{ |d| '%02x' % d }.join(':').to_s,
                                                                          list: [List.find_by_name('Whitelist'),
                                                                                   List.find_by_name('Whitelist'),
                                                                                   List.find_by_name('Whitelist'),
                                                                                   List.find_by_name('Whitelist'),
                                                                                   List.find_by_name('Unassigned')].sample),
                                                    name: 'com.example.' + Faker::Internet.user_name,
                                                    expiration: Faker::Time.between(2.days.ago, Faker::Time.forward(23, :morning)),
                                                    mask: mask,
                                                    kind: ['D','B','U','R','N'].sample)
          sweep.nodes << Node.create(ip: server.scopes.last.leases.last.ip,
                                     mac: server.scopes.last.leases.last.device.mac)
          sweep.nodes << Node.create(ip: sweeper.ip,
                                     mac: sweeper.mac)
        end
        rand(12).times do
          sweepdup = Sweep.create(description: cidr4.to_s, created_at: Faker::Time.between(2.days.ago, Faker::Time.backward(1.hour)))
          sweepdup.nodes = sweep.nodes
        end
      end
    end
    5.times do
      device = Device.all.sample
      device.list = List.find_by_name('Blacklist')
      device.notes = Faker::Lorem.sentence(3)
      device.save
    end
  end
end
