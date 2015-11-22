require 'rails_helper'

RSpec.describe Device, type: :model do
  before(:all) do
    Lease.all.destroy_all
    @list = List.find_by_name('Unassigned')
    #Device.all.destroy_all
  end
  after(:all) do
    Device.all.destroy_all
  end
  it "is invalid if empty" do
    device = Device.new()
    expect(device).to be_invalid
  end

  it "is invalid if MAC is not set" do
    device = Device.new(mac: '', list: @list)
    expect(device).to be_invalid
  end

  it "is invalid if list is not set" do
    device = Device.new(mac: '00:1f:f3:cd:62:f2', list: nil)
    expect(device).to be_invalid
  end

  it 'is valid if the mac and list are valid' do
    device = Device.new(mac: '00:1f:f3:cd:62:f2', list: @list)
    expect(device).to be_valid
  end

  it "is unique" do
    device = Device.create(mac: '00:1f:f3:cd:62:f2', list: @list)
    duplicate_device = Device.new(mac: device.mac)
    expect(duplicate_device).to be_invalid
  end
  it "should we remove the colons from the mac?"
  
  
  it "is invalid if mac is not long enough" do
    device = Device.new(mac: '00:1f:f3:cd:62:d', list: @list)
    expect(device).to be_invalid
  end

  it "is invalid if mac is too long" do
    device = Device.new(mac: '00:1f:f3:cd:62:d22', list: @list)
    expect(device).to be_invalid
  end

  it "is invalid if mac is has invalid characters" do
    device = Device.new(mac: '00:1f:f3:cd:62:g2', list: @list)
    expect(device).to be_invalid
  end 
end
