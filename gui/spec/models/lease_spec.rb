require 'rails_helper'

RSpec.describe Lease, type: :model do
  before(:each) do
    FactoryGirl.create(:list, name: 'Unassigned')
    @device = FactoryGirl.create(:device)
  end

  it 'is invalid if IP is empty' do
    lease = Lease.new(ip: '')
    expect(lease).to be_invalid
  end

  it 'is invalid if device is empty' do
    lease = Lease.new(ip: '1.1.1.1', device: nil, expiration: Faker::Time)
    expect(lease).to be_invalid
  end

  it 'is invalid if expiration is empty' do
    lease = Lease.new(ip: '1.1.1.1', device: @device, expiration: nil)
    expect(lease).to be_invalid
  end

  it 'is valid if IP, device, expiration are defined' do
    lease = Lease.new(ip: '1.1.1.1', device: @device, expiration: Faker::Time)
    expect(lease).to be_valid
  end

  it 'has a mask'

  describe 'kind' do # called type by M$
    it 'is valid if D' # DHCP
    it 'is valid if B' # BOOTP
    it 'is valid if U' # UNSPECIFIED
    it 'is valid if R' # RESERVATION IP
    it 'is valid if N' # NONE
    it 'is invalid if not DBURN'
  end

  it 'belongs to a scope'
  it 'has a name'
end
