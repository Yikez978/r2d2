require 'rails_helper'

RSpec.describe "API" do
  describe 'POST /sweeps' do
    describe 'when unsuccessful' do
      it 'should create all devices' do
        post 'http://api.example.com/api/sweeps/',
          { sweep:
            { description: '1.1.1.0/24', devices_attributes:
              [{ mac: '00:11:22:33:44:55',ip: '1.1.1.1' },{ mac: '00:11:22:33:44:55',ip: '1.1.1.2' }]
            }
          }.to_json,
          { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
        expect(Device.find_by_mac('00:11:22:33:44:55').id).to be_truthy
        expect(Device.find_by_ip('1.1.1.2').id).to be_truthy
      end
    end
  end
end