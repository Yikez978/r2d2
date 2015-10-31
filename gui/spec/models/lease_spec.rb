require 'rails_helper'

RSpec.describe Lease, type: :model do
  it 'is invalid if IP is empty' do
    lease = Lease.new()
    expect(lease).to be_invalid
  end
  it 'is valid if IP defined' do
    lease = Lease.new(ip: '1.1.1.1')
    expect(lease).to be_valid
  end
end
