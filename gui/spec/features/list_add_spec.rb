require 'rails_helper'

RSpec.describe 'list', type: :feature do
  describe 'add page' do
    before(:all) { List.all.delete_all }
    before(:each) do
      visit new_list_path
    end
    it 'has the new url' do
      expect(current_path).to eq(new_list_path)
    end
    describe 'filling out form to add a list' do
      describe 'cannot add' do
        before(:each) { @list = FactoryGirl.create(:list) }
        it 'blank name' do
          click_button 'Save'
          expect(page).to have_content("Name can't be blank")
          #expect(current_path).to eq(new_list_path)
        end
        it 'duplicate name' do
          fill_in 'Name', with: @list.name
          click_button 'Save'
          expect(page).to have_content("Name has already been taken")
          #expect(current_path).to eq(new_list_path)
        end
        it 'case-insensitive duplicate name'
      end
      it 'adds the list to lists' do
        list_count = List.count
        fill_in 'Name', with: 'fred'
        click_button 'Save'
        expect(List.count).to eq(list_count+1)
        expect(List.find_by_name('fred').valid?).to eq(true)
      end
      it 'displays success message' do
        fill_in 'Name', with: "Fred's Angels"
        click_button 'Save'
        expect(page).to have_content("Added new list Fred's Angels")
      end
      it 'has a count of zero'
      it 'assigns the default glyph if not changed'
      it 'assigns the selected glyph'
      it 'redirects to the lists page'
    end
  end
end