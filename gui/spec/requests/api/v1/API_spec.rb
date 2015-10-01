require 'rails_helper'

RSpec.describe "API" do
  describe "GET /devices" do
    #let!(:device) { FactoryGirl.create(:device) }
    before(:each) do
      10.times { FactoryGirl.create(:device) }
      get 'http://api.example.com/devices'
    end

    it 'should return status 200' do
      expect(response).to be_success
    end

    it 'should return all the devices in JSON' do
      json = JSON.parse(response.body)
      devices = json.collect { |d| d[:id] }
      expect(devices.length).to eq(10)
    end
  end
  
  describe 'GET /devices/:id' do
    before(:each) do
      2.times { FactoryGirl.create(:device) }
      get "http://api.example.com/devices/#{Device.first.id}"
    end
    
    it 'should return the requested device' do
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:id]).to eq(Device.first.id)
    end

    it 'should not return other devices' do
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json).to_not match(Device.last.to_json)
    end
  end

  describe 'POST /devices' do
    before(:each) do
      post 'http://api.example.com/devices/',
        { device:
          { mac: '00:11:22:33:44:55', ip: '1.1.1.1' }
        }.to_json,
        { 'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s }
    end

    it 'should return status 201' do
      expect(response).to be_created
    end

    it 'should create a device'do
      expect(Device.find_by_mac('00:11:22:33:44:55')).to be_valid
    end
  end
end