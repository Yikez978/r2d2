require 'rails_helper'

RSpec.describe Glyph, type: :model do
  describe 'is invalid if it' do
    it 'has a blank name' do
      expect(Glyph.new(name: '')).to be_invalid
    end
    it 'has a duplicate name' do
      glyph = Glyph.create(name: 'fred')
      expect(Glyph.new(name: 'fred')).to be_invalid
      glyph.destroy
    end
  end
end
