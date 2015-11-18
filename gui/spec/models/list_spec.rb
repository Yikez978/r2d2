require 'rails_helper'

RSpec.describe List, type: :model do
    describe 'name' do
      it 'is invalid if name is nil' do
        list = List.new(name: nil)
        expect(list).to be_invalid
      end
      it 'is valid if the name has a value' do
        list = List.new(name: 'Unassigned')
        expect(list).to be_valid
      end
      it 'is unique' do
        List.create(name: 'Highlander')
        list2 = List.new(name: 'Highlander')
        expect(list2).to be_invalid
      end
    end
end
