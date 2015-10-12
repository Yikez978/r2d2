require 'rails_helper'

RSpec.describe "l2s2", type: :feature do
  describe "GET /" do
    describe 'home page' do
      let!(:sweep) { FactoryGirl.create(:sweep) }
      before(:each) do
        visit '/'
      end
      it 'should have the program name' do
        expect(page).to have_title('Layer 2 Sweeper Service')
      end
      it 'should have link l2s2 to root' do
        expect(page).to have_link('Layer 2 Sweeper Service', :href => '/')
      end
      it 'should have Home as the page description in the navbar' do
        expect(page.all('.navbar')[0]).to have_content('Home')
      end
      it 'should have link to r2d2' do
        expect(page).to have_link('r2d2', :href => '/home_pages/r2d2')
      end
      it 'should take you to the r2d2 home page when clicking the r2d2 link' do
        click_link('r2d2')
        expect(current_path).to eq('/home_pages/r2d2')
      end
      it 'should display a table' do
        expect(page).to have_selector('table tr')
      end
      describe 'table' do
        it 'should have a header' do
          expect(page).to have_selector('thead')
        end
        describe 'header' do
          it 'should have Description' do
            expect(page.all('th')[0]).to have_content('Description')
          end
          it 'should have Date' do
            expect(page.all('th')[1]).to have_content('Date')
          end
          it 'should have Device Count' do
            expect(page.all('th')[2]).to have_content('Device Count')
          end
        end
        describe 'data row' do
          it 'should have a link to display the details' do
            expect(page.find_link(sweep.description, "/sweeps/#{sweep.id}"))
          end
          it 'should display the description' do
            expect(page.all('td')[0]).to have_content(sweep.description)
          end
          it 'should display the date' do
            expect(page.all('td')[1]).to have_content(sweep.created_at)
          end
          it 'should display the number of devices' do
            expect(page.all('td')[2]).to have_content(sweep.devices.count)
          end
        end
        describe 'should be sortable' do
          it 'by description'
          it 'by date'
          it 'by device count'
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
      end
    end
  end
  describe 'Get /sweeps/:id' do
    let!(:sweep) { FactoryGirl.create(:sweep) }
    before(:each) { visit "/sweeps/#{sweep.id}" }
    it 'should have the sweep description in the navbar' do
      expect(page.all('.navbar-text')[0]).to have_content(sweep.description)
    end
    describe 'table' do
      it 'should be sortable by MAC'
      it 'should be sortable by IP'
      describe 'headings' do
        it 'should have thead' do
          expect(page).to have_selector('thead')
        end
        it 'should have MAC' do
          expect(page.all('th')[0]).to have_content('MAC')
        end
        it 'should have IP' do
          expect(page.all('th')[1]).to have_content('IP')
        end
      end
      describe 'data row' do
        it 'should have a link to display the details' do
          expect(page.find_link(sweep.devices[0].mac,"/devices/#{sweep.devices[0].id}"))
        end
        it 'should display the MAC' do
          expect(page.all('td')[0]).to have_content(sweep.devices[0].mac)
        end
        it 'should display the IP' do
          expect(page.all('td')[1]).to have_content(sweep.devices[0].ip)
        end
      end
    end
  end
  describe 'Clicking MAC of a /sweeps/:id item' do
    let!(:sweep) { FactoryGirl.create(:sweep) }
    before(:each) do
      visit "/sweeps/#{sweep.id}"
      click_link(sweep.devices[0].mac)
    end
    it 'should go to /devices/:id' do
      expect(current_path).to eq("/devices/#{sweep.devices[0].id}")
    end
    it 'should have the device MAC in the description in the navbar' do
      expect(page.all('.navbar-text')[0]).to have_content(sweep.devices[0].mac)
    end
    describe 'table' do
      describe 'headings' do
        it 'should have IP' do
          expect(page.all('th')[0]).to have_content('IP')
        end
        it 'should have Sweep' do
          expect(page.all('th')[1]).to have_content('Sweep')
        end
      end
      describe 'data row' do
        it 'should display the IP' do
          expect(page.all('td')[0]).to have_content(sweep.devices[0].ip)
        end
        it 'should display the Sweep timestamp' do
          expect(page.all('td')[1]).to have_content(sweep.devices[0].created_at)
        end
        # the next test is bad - passes when it shouldn't
        # need to create multiple sweeps and devices?
        it 'should have a link to the Sweep' do
          expect(page.find_link(sweep.devices[0].created_at,"/sweeps/#{sweep.id}"))
        end
      end
    end
  end
end