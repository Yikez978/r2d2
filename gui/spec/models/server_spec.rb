require 'rails_helper'

RSpec.describe Server, type: :model do
  it 'is invalid if name is empty' do
    server = Server.new(ip: '1.1.1.1')
    expect(server).to be_invalid
  end
  it 'is valid if name is not empty' do
    server = Server.new(name: 'server', ip: '1.1.1.1')
    expect(server).to be_valid
  end
  it 'is invalid if ip is empty' do
    server = Server.new(name: 'server')
    expect(server).to be_invalid
  end
  it 'is valid if ip is not empty' do
    server = Server.new(ip: '1.1.1.1', name: 'server')
    expect(server).to be_valid
  end
  it  'the name is unique' do
    server1 = Server.create(ip: '1.1.1.1', name: 'server')
    server2 = Server.new(ip: '1.1.1.2', name: 'server')
    expect(server1).to be_valid
    expect(server2).to be_invalid
  end
  it 'the IP is unique' do
    server1 = Server.create(ip: '1.1.1.1', name: 'server1')
    server2 = Server.new(ip: '1.1.1.1', name: 'server2')
    expect(server1).to be_valid
    expect(server2).to be_invalid
  end
end
