require 'rails_helper'

RSpec.describe Lease, type: :model do
  before(:each) {
    FactoryGirl.create(:device)
  }
  it 'is invalid if IP is empty' do
    lease = Lease.new(ip: '')
    expect(lease).to be_invalid
  end
  it 'is invalid if device is empty' do
    lease = Lease.new(ip: '1.1.1.1', device: nil)
    expect(lease).to be_invalid
  end
  it 'is valid if IP and device are defined' do
    lease = Lease.new(ip: '1.1.1.1', device: device)
    expect(lease).to be_valid
  end
  it 'has an expiration'
  it 'has a mask'
  describe 'kind' do
    it 'is valid if D'
    it 'is valid if B'
    it 'is valid if U'
    it 'is valid if R'
    it 'is valid if N'
    it 'is invalid if not DBURN'
  end
  it 'belongs to a scope'
  it 'has a device'
  it 'has a name'
end
