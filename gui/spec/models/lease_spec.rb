require 'rails_helper'

RSpec.describe Lease, type: :model do
  it 'is invalid if IP is empty' do
    lease = Lease.new(mac:'00:1f:f3:cd:62:d2')
    expect(lease).to be_invalid
  end
  it 'is invalid if MAC is empty' do
    lease = Lease.new(ip:'1.1.1.1')
    expect(lease).to be_invalid
  end
  it 'is valid if IP and MAC defined' do
    lease = Lease.new(ip: '1.1.1.1', mac: '00:1f:f3:cd:62:d2')
    expect(lease).to be_valid
  end
  describe 'mac' do
    it "is invalid if not long enough" do
      lease = Lease.new(mac: '00:1f:f3:cd:62:d', ip: '192.168.1.1')
      expect(lease).to be_invalid
    end
    it "is invalid if too long" do
      lease = Lease.new(mac: '00:1f:f3:cd:62:d22', ip: '192.168.1.1')
      expect(lease).to be_invalid
    end
    it "is invalid if it has invalid characters" do
      lease = Lease.new(mac: '00:1f:f3:cd:62:g2', ip: '192.168.1.1')
      expect(lease).to be_invalid
    end
  end
end
