require 'rails_helper'

RSpec.describe List, type: :model do
  describe 'name' do
    it 'is invalid if name is nil' do
      list = List.new(name: nil)
      expect(list).to be_invalid
    end
    it 'is valid if the name has a value' do
      list = List.new(name: 'Unassigned-2')
      expect(list).to be_valid
    end
    it 'is unique' do
      list = List.create(name: 'Highlander')
      list2 = List.new(name: 'Highlander')
      expect(list2).to be_invalid
      list.delete
    end
  end
  describe 'glyph' do
    it 'defaults to glyphicon-warning-sign' do
      list = List.create(name: 'default')
      expect(list.glyph).to eq('glyphicon-warning-sign')
      list.delete
    end
    it 'can be set to glyphicon-star' do
      list = List.new(name: 'star', glyph: 'glyphicon-star')
      expect(list).to be_valid
      list.delete
    end
    it 'can be set to glyphicon-eye-open' do
      list = List.new(name: 'star', glyph: 'glyphicon-eye-open')
      expect(list).to be_valid
      list.delete
    end
  end
end
