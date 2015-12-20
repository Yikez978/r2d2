require 'rails_helper'

RSpec.describe Node, type: :model do
    it "is invalid if empty" do
    @node = Node.new()
    expect(@node).to be_invalid 
  end

  it "is invalid if mac is not set" do
    @node = Node.new(ip: '192.168.1.1')
    expect(@node).to be_invalid
  end

  it "is invalid if IP is not set" do
    @node = Node.new(mac: '00:1f:f3:cd:62:d2')
    expect(@node).to be_invalid
  end

  it "should we remove the colons from the mac?"
  it "should have a unique mac?"
  
  it "is valid if required fields are set" do
    @node = Node.new(mac: '00:1f:f3:cd:62:d2', ip: '192.168.1.1')
    expect(@node).to be_valid
  end
  it "is invalid if mac is not long enough" do
    @node = Node.new(mac: '00:1f:f3:cd:62:d', ip: '192.168.1.1')
    expect(@node).to be_invalid
  end

  it "is invalid if mac is too long" do
    @node = Node.new(mac: '00:1f:f3:cd:62:d22', ip: '192.168.1.1')
    expect(@node).to be_invalid
  end

  it "is invalid if mac is has invalid characters" do
    @node = Node.new(mac: '00:1f:f3:cd:62:g2', ip: '192.168.1.1')
    expect(@node).to be_invalid
  end  
end
