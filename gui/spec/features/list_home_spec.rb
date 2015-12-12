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
            expect(element['class']).to match(List.first.glyph.name)
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
          before(:each) do
            @edit_list = FactoryGirl.create(:list)
            visit lists_path
          end
          after(:each) { @edit_list.delete }
          it 'takes you to the edit list page' do
            within(page.all('td')[15]) do
              all('.btn')[0].click
            end
            expect(current_path).to eq(edit_list_path(@edit_list.id))
          end
        end
        it 'displays the delete icon' do
          within(page.all('td')[3]) do
            element = all('span')[1]
            expect(element['class']).to match('glyphicon-remove')
          end
        end
        describe 'clicking the delete icon' do
          before(:each) do
            @delete_list = FactoryGirl.create(:list)
            visit lists_path
            within(page.all('td')[15]) do
              all('.btn')[1].click
            end
          end
          describe 'on the protected lists' do
            ['Unassigned', 'Whitelist', 'Blacklist'].each do |l|
              it 'pops alert that the list cannot be deleted'
            end
          end
          it 'reassigns members to unassigned' do
            @unassigned_count_b4 = Device.where(list: List.find_by_name('Unassigned')).count
            FactoryGirl.create(:device, list: @delete_list)
            accept_confirm do
              within(page.all('td')[15]) do
                all('.btn')[1].click
              end
            end
            expect(Device.where(list: List.find_by_name('Unassigned')).count).to eq(@unassigned_count_b4+1)
          end
          it 'deletes the list after confirmation' do
            accept_confirm do
              within(page.all('td')[15]) do
                all('.btn')[1].click
              end
            end
            expect(page).not_to have_content(@delete_list.name)
          end
          it 'displays success message' do
            accept_confirm do
              within(page.all('td')[15]) do
                all('.btn')[1].click
              end
            end
            expect(page).to have_content("Deleted list named '#{@delete_list_name}'.")
          end
          it 'does not delete the list if cancelled' do
            dismiss_confirm do
              within(page.all('td')[15]) do
                all('.btn')[1].click
              end
            end
            expect(page).to have_content(@delete_list.name)
          end
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
    describe 'clicking the Add button' do
      it 'takes you to the new list page' do
        click_link('Add')
        expect(current_path).to eq(new_list_path)
      end
    end
    describe 'sort list' do
      describe 'by name'
    end
  end
end
