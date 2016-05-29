require 'rails_helper'

RSpec.describe "l2s2", type: :feature do
  describe "GET /l2s2" do
    describe 'home page' do
      before(:each) do
        visit '/l2s2'
      end
      it 'should have the program name' do
        expect(page).to have_title('Layer 2 Sweeper Service')
      end
      it 'should have link l2s2 to root' do
        expect(page).to have_link('Layer 2 Sweeper Service', :href => '/l2s2')
      end
      it 'should have Home as the page description in the navbar' do
        expect(page.all('.navbar')[0]).to have_content('Home')
      end
      it 'should have link to r2d2' do
        expect(page).to have_link('r2d2', :href => '/r2d2')
      end
      it 'should take you to the r2d2 home page when clicking the r2d2 link' do
        click_link('r2d2')
        expect(current_path).to eq('/r2d2')
      end
      it 'should display a table' do
        expect(page).to have_selector('table tr')
      end
      describe 'table' do
        it 'should have a header' do
          expect(page).to have_selector('thead')
        end
        describe 'header' do
          it 'has a Description column' do
            expect(page.all('th')[0]).to have_content('Description')
          end
          it 'has an IP address column' do
            expect(page.all('th')[1]).to have_content('IP')
          end
          it 'has a MAC address column' do
            expect(page.all('th')[2]).to have_content('MAC')
          end
        end
        describe 'data row' do
          let!(:sweeper) { FactoryGirl.create(:sweeper) }
          before(:each) do
            visit "/sweepers"
          end
          it 'had a link to display the sweeper details' do
            expect(page.find_link(sweeper.description, "/sweepers/#{sweeper.id}"))
          end
          it 'displays the sweeper description' do
            expect(page.all('td')[0]).to have_content(sweeper.description)
          end
          it 'displays the sweeper IP address' do
            expect(page.all('td')[1]).to have_content(sweeper.ip)
          end
          it 'displays the sweeper MAC address' do
            expect(page.all('td')[2]).to have_content(sweeper.mac)
          end
        end
        describe 'should be sortable' do
          it 'by description'
          it 'by IP'
          it 'by MAC'
        end
      end
      describe 'big table' do
        before(:each) do
          11.times { FactoryGirl.create(:sweeper) }
          visit "/sweepers"
        end
        it 'should paginate if more than 10 rows' do
          print page.html
          expect(page).to have_selector('div.pagination')
        end
      end
      describe 'clicking a sweeper description' do
        let!(:sweeper) { FactoryGirl.create(:sweeper) }
        before(:each) do
          visit '/sweepers'
          click_link(sweeper.description)
        end
        it 'should go to /sweeps/:id' do
          expect(current_path).to eq("/sweepers/#{sweeper.id}")
        end
      end
    end
  end
end
