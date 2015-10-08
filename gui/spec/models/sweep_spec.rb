require 'rails_helper'

RSpec.describe Sweep, type: :model do
  it 'is invalid if description is empty' do
    sweep = Sweep.new()
    expect(sweep).to be_invalid
  end
  it 'is valid if description is not empty' do
    sweep = Sweep.new(description: '192.168.1.0/24')
    expect(sweep).to be_valid
  end
end
