require 'rails_helper'

RSpec.describe Sweep, type: :model do
  it "is invalid if empty" do
    sweep = Sweep.new()
    expect(sweep).to be_invalid
  end
end
