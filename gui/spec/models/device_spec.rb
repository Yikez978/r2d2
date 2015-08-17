require 'rails_helper'

RSpec.describe Device, type: :model do
  it "is invalid if empty" do
    @device = Device.new()
    expect(@device).to be_invalid
  end

  it "is invalid if mac is not set" do
    @device = Device.new(ip: '192.168.1.1')
    expect(@device).to be_invalid
  end

  it "is invalid if IP is not set" do
    @device = Device.new(mac: '00:1f:f3:cd:62:d2')
    expect(@device).to be_invalid
  end

  it "should we remove the colons from the mac?"
  it "should have a unique mac?"
  
  it "is valid if required fields are set" do
    @device = Device.new(mac: '00:1f:f3:cd:62:d2', ip: '192.168.1.1')
    expect(@device).to be_valid
  end
  it "is invalid if mac is not long enough" do
    @device = Device.new(mac: '00:1f:f3:cd:62:d', ip: '192.168.1.1')
    expect(@device).to be_invalid
  end

  it "is invalid if mac is too long" do
    @device = Device.new(mac: '00:1f:f3:cd:62:d22', ip: '192.168.1.1')
    expect(@device).to be_invalid
  end

  it "is invalid if mac is has invalid characters" do
    @device = Device.new(mac: '00:1f:f3:cd:62:g2', ip: '192.168.1.1')
    expect(@device).to be_invalid
  end  

  it "is invalid if the IP in invalid"
  it "do we want th ip to be a string or a number"
  it "should be a unique IP?"
end
