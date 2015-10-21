require 'rails_helper'

RSpec.describe "r2d2", type: :feature do
  describe "GET /r2d2" do
    describe 'home page' do
      let!(:server ) { FactoryGirl.create(:server, scope_count: 11) }
      before(:each) do
        visit '/r2d2'
      end
      it 'should have the program name' do
        expect(page).to have_title('Remote Rogue Device Detector')
      end
      it 'should have link r2d2 to root' do
        expect(page).to have_link('Remote Rogue Device Detector', :href => '/r2d2')
      end
      it 'should have Home as the page description in the navbar' do
        expect(page.all('.navbar')[0]).to have_content('Home')
      end
      it 'should have link to l2s2' do
        expect(page).to have_link('l2s2', :href => '/l2s2')
      end
      it 'should take you to the l2s2 home page when clicking the l2s2 link' do
        click_link('l2s2')
        expect(current_path).to eq('/l2s2')
      end
      it 'should display a table' do
        expect(page).to have_selector('table')
      end
      describe 'table' do
        it 'should have a header' do
          expect(page).to have_selector('thead')
        end
        describe 'header' do
          it 'should have DHCP-MAC' do
            expect(page.all('th')[0]).to have_content('DHCP-MAC')
          end
          it 'should have Note' do
            expect(page.all('th')[1]).to have_content('Note')
          end
          it 'should have DHCP-HOST' do
            expect(page.all('th')[2]).to have_content('DHCP-HOST')
          end
          it 'should have ScopeDesc' do
            expect(page.all('th')[3]).to have_content('ScopeDesc')
          end
          it 'should have ScopeComment' do
            expect(page.all('th')[4]).to have_content('ScopeComment')
          end
          it 'should have IP' do
            expect(page.all('th')[5]).to have_content('IP')
          end
          it 'should have Lease' do
            expect(page.all('th')[6]).to have_content('Lease')
          end
          it 'should have Vendor' do
            expect(page.all('th')[7]).to have_content('Vendor')
          end
          it 'should have NetBIOS-MAC' do
            expect(page.all('th')[8]).to have_content('NetBIOS-MAC')
          end
          it 'should have NetBIOS-Host' do
            expect(page.all('th')[9]).to have_content('NetBIOS-Host')
          end
          it 'should have Ping' do
            expect(page.all('th')[10]).to have_content('Ping')
          end
          it 'should have P4445' do
            expect(page.all('th')[11]).to have_content('P4445')
          end
          it 'should have C$' do
            expect(page.all('th')[12]).to have_content('C$')
          end
          it 'should have AV' do
            expect(page.all('th')[13]).to have_content('AV')
          end
          it 'should have EPO' do
            expect(page.all('th')[14]).to have_content('EPO')
          end
          it 'should have P80' do
            expect(page.all('th')[15]).to have_content('P80')
          end
          it 'should have DHCP-Server' do
            expect(page.all('th')[16]).to have_content('DHCP-Server')
          end
        end
        describe 'data row' do
          it 'should have a link to display the details' do
            expect(page.find_link(server.scopes[0].leases[0].mac, "/leases/#{server.scopes[0].leases[0].id}"))
          end
          it 'should have DHCP name' do
            expect(page.all('td')[2]).to have_content(server.scopes[0].leases[0].name)
          end
          it 'should have scope description' do
            expect(page.all('td')[3]).to have_content(server.scopes[0].description)
          end
          it 'should have scope comment' do
            expect(page.all('td')[4]).to have_content(server.scopes[0].comment)
          end
          it 'should have IP' do
            expect(page.all('td')[5]).to have_content(server.scopes[0].leases[0].ip)
          end
          it 'should have lease expiration datetime' do
            expect(page.all('td')[6]).to have_content(server.scopes[0].leases[0].expiration)
          end
          it 'should have DHCP-Server IP' do
            expect(page.all('td')[16]).to have_content(server.ip)
          end
        end
      end
      it 'should have pagination controls' do
        expect(page).to have_selector('div.pagination')
      end
    end
  end
end