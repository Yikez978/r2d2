require 'rails_helper'

RSpec.describe Scope, type: :model do
  it 'is invalid if IP is empty' do
    scope = Scope.new()
    expect(scope).to be_invalid
  end
  it 'is valid if IP is not empty' do
    scope = Scope.new(ip: '1.1.1.1')
    expect(scope).to be_valid
  end
  it 'the IP is unique' do
    scope1 = Scope.create(ip: '1.1.1.1')
    scope2 = Scope.new(ip: '1.1.1.1')
    expect(scope1).to be_valid
    expect(scope2).to be_invalid
  end
end
