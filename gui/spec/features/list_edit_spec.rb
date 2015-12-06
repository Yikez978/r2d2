require 'rails_helper'

RSpec.describe 'list', type: :feature do
  describe 'edit page' do
    before(:all) { List.all.delete_all }
    before(:each) do
      @list = FactoryGirl.create(:list)
      visit edit_list_path(@list)
    end
    after(:each) { List.find(@list.id).delete }
    it 'has the edit url' do
      expect(current_path).to eq(edit_list_path(@list))
    end
    describe 'filling in field for name and clicking save' do
      it 'changes the name' do
        old_name = @list.name
        fill_in 'Name', with: 'fred'
        click_button 'Save'
        expect(page.all('td')[1]).to have_content('fred')
        expect(page).not_to have_content(old_name)
      end
      it 'does not add a new list' do
        list_count = List.count
        fill_in 'Name', with: 'freed'
        click_button 'Save'
        expect(List.count).to eq(list_count)
        expect(List.find_by_name('freed').valid?).to eq(true)
      end
      it 'displays success message' do
        fill_in 'Name', with: "Fred's Angels"
        click_button 'Save'
        expect(page).to have_content("List updated")
      end
      describe 'cannot add' do
        before(:each) { @list2 = FactoryGirl.create(:list) }
        it 'blank name' do
          fill_in 'Name', with: ''
          click_button 'Save'
          expect(page).to have_content("Name can't be blank")
        end
        it 'duplicate name' do
          fill_in 'Name', with: @list2.name
          click_button 'Save'
          expect(page).to have_content("Name has already been taken")
        end
        it 'case-insensitive duplicate name'
      end
      it 'has the same Count as before'
      it 'assigns the selected glyph'
      it 'redirects to the lists page' do
        click_button 'Save'
        expect(current_path).to eq(lists_path)
      end
    end
  end
end