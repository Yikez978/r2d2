require 'rails_helper'

RSpec.describe "l2s2", type: :feature do
  describe "GET /" do
    describe 'home page' do
      let!(:sweep) { FactoryGirl.create(:sweep) }
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
          it 'should have Description' do
            expect(page.all('th')[1]).to have_content('Description')
          end
          
          it 'should have Date' do
            expect(page.all('th')[2]).to have_content('Date')
          end
          it 'should have Device Count' do
            expect(page.all('th')[3]).to have_content('Device Count')
          end
        end
        describe 'data line' do
          it 'should have a link to display the details' do
            expect(page.find_link('Show',"/sweeps/#{sweep.id}"))
          end
          it 'should display the description' do
            expect(page.all('td')[1]).to have_content(sweep.description)
          end
          it 'should display the date' do
            expect(page.all('td')[2]).to have_content(sweep.created_at)
          end
          it 'should display the number of devices' do
            expect(page.all('td')[3]).to have_content(sweep.devices.count)
          end
        end
      end
      describe 'big table' do
        before(:all) { 10.times { FactoryGirl.create(:sweep) } }
        #before(:all) { FactoryGirl.create(:sweep, device_count: 10) }
        after(:all) do
          Sweep.delete_all
          Device.delete_all
        end
        it 'should paginate if more than 10 rows' do
          expect(page).to have_selector('div.pagination')
        end
        it 'should be sortable by MAC'
        it 'should be sortable by IP'
      end
    end
  end
  describe 'Get /sweeps/:id' do
    describe 'table' do
      describe 'headings' do
        let!(:sweep) { FactoryGirl.create(:sweep) }
        before(:each) { visit "/sweeps/#{sweep.id}" }
        it 'should have thead' do
          expect(page).to have_selector('thead')
        end
        it 'should have MAC' do
          expect(page.all('th')[0]).to have_content('MAC')
        end
        it 'should have IP' do
          expect(page.all('th')[1]).to have_content('IP')
        end
        it 'should have First Seen' do
          expect(page.all('th')[2]).to have_content('First Seen')
        end
      end
    end
  end
end