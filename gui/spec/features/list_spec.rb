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
          expect(page.all('td')[5]).to have_content('0')
        end
      end
      describe 'has pagination controls when table has more than 10 rows' do
        before(:each) do
          FactoryGirl.create_list(:list, 11)
          visit '/lists'
        end
        it do
          expect(page).to have_selector('div.pagination')
        end
      end
    end
  end
end
