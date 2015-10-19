require 'netaddr'
FactoryGirl.define do
  factory :device do
    mac  { 6.times.map{ rand(256) }.map{ |d| '%02x' % d }.join(':').to_s }
    ip   Faker::Internet.ip_v4_address
  end
  factory :sweep do
    cidr = (16..29).to_a
    ip = Faker::Internet.ip_v4_address
    description NetAddr::CIDR.create("#{ip}/#{cidr.sample}").to_s
    transient do
      device_count 1
    end
    after(:create) do |sweep, evaluator|
#      create_list(:result, evaluator.device_count, sweep: sweep)
      evaluator.device_count.times  { sweep.devices << create(:device) }
    end
  end

  factory :lease do
    mac  { 6.times.map{ rand(256) }.map{ |d| '%02x' % d }.join(':').to_s }
    ip   Faker::Internet.ip_v4_address
  end
  factory :scope do
    ip   Faker::Internet.ip_v4_address
    mask '255.255.255.0'
    cidr4 = NetAddr::CIDR.create(Faker::Internet.ip_v4_address+'/24')
    ip_array = cidr4.enumerate
    transient do
      lease_count 1
    end
    after(:create) do |scope, evaluator|
      evaluator.lease_count.times  { scope.leases << create(:lease, ip: ip_array.sample) }
    end
  end
  factory :server do
    ip   Faker::Internet.ip_v4_address
    name Faker::Internet.domain_word + ".example.com"
    transient do
      scope_count 1
    end
    after(:create) do |server, evaluator|
      evaluator.scope_count.times do
        mask = (23..29).to_a.sample.to_s
        cidr4 = NetAddr::CIDR.create(Faker::Internet.ip_v4_address+'/'+mask)
        server.scopes << create(:scope, ip: cidr4.to_s, mask: cidr4.wildcard_mask)
      end
    end
  end
end