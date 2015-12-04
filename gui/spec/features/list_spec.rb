require 'rails_helper'

RSpec.describe 'list', type: :feature do
  describe 'GET /lists'do
    before(:each) { visit '/lists' }
    it 'has the program name as the title' do
      expect(page).to have_title('Remote Rogue Device Detector')
    end
    it 'has a link r2d2 to root' do
      expect(page).to have_link('Remote Rogue Device Detector', :href => '/r2d2')
    end
    it 'has Home as the page description in the navbar' do
      expect(page.all('.navbar')[0]).to have_content('Lists')
    end
    it 'displays a table' do
      expect(page).to have_selector('table')
    end
    describe 'table' do
      it 'has a header' do
        expect(page).to have_selector('thead')
      end
      describe 'header' do
        it 'has a Glyph column' do
          expect(page.all('th')[0]).to have_content('Glyph')
        end
        it 'has a Name column' do
          expect(page.all('th')[1]).to have_content('Name')
        end
        it 'has a Count column' do
          expect(page.all('th')[2]).to have_content('Count')
        end
        it 'has a Action column' do
          expect(page.all('th')[3]).to have_content('Action')
        end
      end
      describe 'data row' do
        before(:all) do
          Device.all.destroy_all
          FactoryGirl.create(:device, list: List.first)
        end
        after(:all) { Device.all.destroy_all }
        it 'displays the list glyph' do
          within(page.all('td')[0]) do
            element = all('span')[0]
            expect(element['class']).to match(List.first.glyph)
          end
        end
        it 'displays the list name' do
          expect(page.all('td')[1]).to have_content(List.first.name)
        end
        it 'displays the member count' do
          expect(page.all('td')[2]).to have_content('1')
        end
        it 'displays the member count if zero' do
          expect(page.all('td')[6]).to have_content('0')
        end
        it 'displays the edit icon' do
          within(page.all('td')[3]) do
            element = all('span')[0]
            expect(element['class']).to match('glyphicon-pencil')
          end
        end
        describe 'clicking the edit icon' do
          it 'takes you to the edit list page' do
          within(page.all('td')[3]) do
            all('button')[0].click
          end
          expect(current_path).to eq(edit_list_path)
          end
        end
        it 'displays the delete icon' do
          within(page.all('td')[3]) do
            element = all('span')[1]
            expect(element['class']).to match('glyphicon-remove')
          end
        end
        describe 'clicking the delete icon' do
          it 'reassigns members to unassigned'
          it 'deletes the list after confirmation'
        end
      end
    end
    describe 'has pagination controls when table has more than 10 rows' do
      before(:each) do
        FactoryGirl.create_list(:list, 11)
        visit '/lists'
      end
      after(:each) do
        List.all.delete_all
      end
      it do
        expect(page).to have_selector('div.pagination')
      end
    end
    describe 'filling out form to add list' do
      it 'cannot add blank anem'
      it 'cannot add duplicate name'
      it 'adds list to lists'
      it 'assigns the default glyph if not changed'
      it 'assigns the selected glyph'
    end
    describe 'sort list' do
      describe 'by name'
      describe 'by count'
    end
  end
end
