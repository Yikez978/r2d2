require 'rails_helper'

RSpec.describe Server, type: :model do
  describe 'is invalid' do
    it 'if name is empty' do
      server = Server.new(ip: '1.1.1.1')
      expect(server).to be_invalid
    end
    it 'if ip is empty' do
      server = Server.new(name: 'server')
      expect(server).to be_invalid
    end
    it 'if IP is invalid' do
      server = Server.new(ip: '1.1.1', name: 'server')
      expect(server).to be_invalid
    end
    it 'if the name is not unique' do
      Server.create(ip: '1.1.1.1', name: 'server')
      server2 = Server.new(ip: '1.1.1.2', name: 'server')
      expect(server2).to be_invalid
    end
    it 'if the IP is not unique' do
      Server.create(ip: '1.1.1.1', name: 'server1')
      server2 = Server.new(ip: '1.1.1.1', name: 'server2')
      expect(server2).to be_invalid
    end
  end
  describe 'is valid' do
    it 'if name is not empty' do
      server = Server.new(name: 'server', ip: '1.1.1.1')
      expect(server).to be_valid
    end
    it 'if ip is not empty' do
      server = Server.new(ip: '1.1.1.1', name: 'server')
      expect(server).to be_valid
    end
  end
end
