require 'rails_helper'

RSpec.describe Device, type: :model do
  it "is invalid if empty" do
    device = Device.new()
    expect(device).to be_invalid
  end

  it "is invalid if MAC is not set" do
    device = Device.new(mac: '')
    expect(device).to be_invalid
  end

  it 'is valid if the mac is valid' do
    device = Device.new(mac: '00:1f:f3:cd:62:f2')
    expect(device).to be_valid
  end

  it "is unique" do
    device = Device.create(mac: '00:1f:f3:cd:62:f2')
    duplicate_device = Device.new(mac: device.mac)
    expect(duplicate_device).to be_invalid
  end
  it "should we remove the colons from the mac?"
  
  
  it "is invalid if mac is not long enough" do
    device = Device.new(mac: '00:1f:f3:cd:62:d')
    expect(device).to be_invalid
  end

  it "is invalid if mac is too long" do
    device = Device.new(mac: '00:1f:f3:cd:62:d22')
    expect(device).to be_invalid
  end

  it "is invalid if mac is has invalid characters" do
    device = Device.new(mac: '00:1f:f3:cd:62:g2')
    expect(device).to be_invalid
  end 
  
  describe 'status' do
    it 'is valid if nil' do
      device = Device.new(mac: '00:1f:f3:cd:62:f2', status: nil)
      expect(device).to be_valid
    end
    it 'is valid if W' do
      device = Device.new(mac: '00:1f:f3:cd:62:f2', status: 'W')
      expect(device).to be_valid
    end
    it 'is valid if B' do
      device = Device.new(mac: '00:1f:f3:cd:62:f2', status: 'B')
      expect(device).to be_valid
    end
    it 'is invalid if not nil, B or W' do
      device = Device.new(mac: '00:1f:f3:cd:62:f2', status: 'A')
      expect(device).to be_invalid
    end
  end
end
