require 'rails_helper'

RSpec.describe "Devices", type: :feature do
  describe "GET /" do
    describe 'home page' do
      let!(:device) { FactoryGirl.create(:device) }
      before(:each) do
        visit '/'
      end
      it 'should have the program name' do
        expect(page).to have_content('Remote Rogue Device Detector')
      end

      it 'should have link to r2d2' do
        expect(page).to have_link('Go to r2d2 Home', :href => '/home_pages/r2d2')
      end

      it 'should have link to l2s2' do
        expect(page).to have_link('l2s2', :href => '/home_pages/l2s2')
      end

      it 'should take you to the r2d2 home page when clicking the r2d2 link' do
        click_link('Go to r2d2 Home')
        expect(current_path).to eq('/home_pages/r2d2')
      end

      it 'should take you to the l2s2 home page when clicking the l2s2 link' do
        click_link('Go to l2s2 Home')
        expect(current_path).to eq('/home_pages/l2s2')
      end

      describe 'table' do
        it 'should display a table' do
          expect(page).to have_selector('table tr')
          end
        it 'should have a header' do
          expect(page).to have_selector('thead')
        end
        describe 'header' do
          it 'should have a header for MAC' do
            expect(page).to have_content('MAC')
          end
          it 'should have a header for IP' do
            expect(page).to have_content('IP')
          end
        end
        describe 'data line' do
          it 'should display the MAC' do
            expect(page).to have_content(device.mac)
          end
          it 'should display the IP' do
            expect(page).to have_content(device.ip)
          end
        end
      end
      describe 'big table' do
        before(:all) { 10.times { FactoryGirl.create(:device) } }
        after(:all)  { Device.delete_all }
        it 'should paginate if more than 10 rows' do
          expect(page).to have_selector('div.pagination')
        end
        it 'should be sortable by MAC'
        it 'should be sortable by IP'
      end
    end
  end
end