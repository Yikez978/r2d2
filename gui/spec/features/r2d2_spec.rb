require 'rails_helper'

RSpec.describe 'r2d2', type: :feature do
  describe 'GET /r2d2' do
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
      it 'has a header' do
        expect(page).to have_selector('thead')
      end
      describe 'header' do
        it 'should have DHCP-MAC' do
          expect(page.all('th')[0]).to have_content('DHCP-MAC')
        end
        it 'should have Status' do
          expect(page.all('th')[1]).to have_content('Status')
        end
        it 'should have DHCP-HOST' do
          expect(page.all('th')[2]).to have_content('DHCP-HOST')
        end
        it 'should have IP' do
          expect(page.all('th')[3]).to have_content('IP')
        end
        it 'should have Lease' do
          expect(page.all('th')[4]).to have_content('Lease')
        end
        it 'should have Vendor' do
          expect(page.all('th')[5]).to have_content('Vendor')
        end

      end
      describe 'has a data row' do
        it 'should have a link to display the details' do
          expect(page.find_link(server.scopes[0].leases[0].device.mac, "/leases/#{server.scopes[0].leases[0].id}"))
        end
        describe 'status column displays' do
          it 'a thumbs up icon if on the whitelist' do
            server.scopes[0].leases[0].device.list = List.find_by_name('Whitelist')
            server.scopes[0].leases[0].device.save
            visit '/r2d2'
            within(page.all('a.dropdown-toggle')[0]) do
              element = all('span')[0]
              expect(element['class']).to match(/glyphicon-thumbs-up/)
              expect(element['class']).to match(/text-success/)
            end
            #expect(page.all('tr')[0]).find('a').to have_css('.glyphicon-thumbs-up')
          end
          it 'a thumbs down icon if on the blacklist' do
            server.scopes[0].leases[0].device.list = List.find_by_name('Blacklist')
            server.scopes[0].leases[0].device.save
            visit '/r2d2'
            within(page.all('a.dropdown-toggle')[0]) do
              element = all('span')[0]
              expect(element['class']).to match(/glyphicon-thumbs-down/)
              expect(element['class']).to match(/text-danger/)
            end
          end
          it 'an unchecked square if not on either list' do
            server.scopes[0].leases[0].device.ist = List.find_by_name('Unassigned')
            server.scopes[0].leases[0].device.save
            visit '/r2d2'
            within(page.all('a.dropdown-toggle')[0]) do
              element = all('span')[0]
              expect(element['class']).to match(/glyphicon-unchecked/)
            end
          end
          describe 'clicking the glyphicon to display the dropdown' do
            it 'displays the selections' do
              server.scopes[0].leases[0].device.ist = List.find_by_name('Unassigned')
              server.scopes[0].leases[0].device.save
              visit '/r2d2'
              link_id = server.scopes[0].leases[0].id.to_s
              click_link(link_id)
              within(page.all('ul.dropdown-menu')[0]) do
                expect(all('li')[0]).to have_content('Remove From List')
                expect(all('li')[1]).to have_content('Add to Whitelist')
                expect(all('li')[2]).to have_content('Add to Blacklist')
              end
            end
            it 'selecting a "Add to Blacklist"' do
              server.scopes[0].leases[0].device.ist = List.find_by_name('Unassigned')
              server.scopes[0].leases[0].device.save
              visit '/r2d2'
              link_id = server.scopes[0].leases[0].id.to_s
              click_link(link_id)
              within(page.all('ul.dropdown-menu')[0]) do
                click_link('Add to Blacklist')
              end
              server.reload
              expect(server.scopes[0].leases[0].device.list).to eq(List.find_by_name('Blacklist'))
            end
            it 'selecting a "Add to Whitelist"' do
              server.scopes[0].leases[0].device.ist = List.find_by_name('Unassigned')
              server.scopes[0].leases[0].device.save
              visit '/r2d2'
              link_id = server.scopes[0].leases[0].id.to_s
              click_link(link_id)
              within(page.all('ul.dropdown-menu')[0]) do
                click_link('Add to Whitelist')
              end
              server.reload
              expect(server.scopes[0].leases[0].device.list).to eq(List.find_by_name('Whitelist'))
            end
            it 'selecting the "Remove From Any List"' do
              server.scopes[0].leases[0].device.list = List.find_by_name('Whitelist')
              server.scopes[0].leases[0].device.save
              visit '/r2d2'
              link_id = server.scopes[0].leases[0].id.to_s
              click_link(link_id)
              within(page.all('ul.dropdown-menu')[0]) do
                click_link('Remove From List')
              end
              server.reload
              expect(server.scopes[0].leases[0].device.list).to eq(List.find_by_name('Unassigned'))
            end
          end
          describe 'a fingerprint icon' do
            it 'with a checkmark if all fingerprint fields are set'
            it 'with an x if not all the fingerprint fields are set'
            it 'with an i if hovered over'
          end
        end
        it 'should have DHCP name' do
          expect(page.all('td')[2]).to have_content(server.scopes[0].leases[0].name)
        end
        it 'should have IP' do
          expect(page.all('td')[3]).to have_content(server.scopes[0].leases[0].ip)
        end
        it 'should have lease expiration datetime' do
          expect(page.all('td')[4]).to have_content(server.scopes[0].leases[0].expiration)
        end
      end
    end
    it 'should have pagination controls' do
      expect(page).to have_selector('div.pagination')
    end
  end
  describe 'clicking a DHCP MAC link' do
    #let!(:scope) { FactoryGirl.create(:scope, lease_count: 1) }
    let!(:server) { FactoryGirl.create(:server, scope_count:1) }
    before(:each) do
      visit '/r2d2'
      click_link "#{server.scopes[0].leases[0].device.mac}"
    end
    it 'should take you to /leases/:id' do
      expect(current_path).to eq("/leases/#{server.scopes[0].leases[0].id}")
    end
    it 'should have the lease MAC in the description in the navbar' do
      expect(page.all('.navbar-text')[0]).to have_content(server.scopes[0].leases[0].device.mac)
    end
    describe 'should display the lease' do
      it 'IP' do
        expect(page.all('p')[1]).to have_content(server.scopes[0].leases[0].ip)
      end
      it 'mask' do
        expect(page.all('p')[1]).to have_content(server.scopes[0].leases[0].mask)
      end
      it 'expiration' do
        expect(page.all('p')[2]).to have_content(server.scopes[0].leases[0].expiration)
      end
      it 'kind' do
        expect(page.all('p')[3]).to have_content(server.scopes[0].leases[0].kind)
      end
      it 'name' do
        expect(page.all('p')[4]).to have_content(server.scopes[0].leases[0].name)
      end
      it 'created_at' do
        expect(page.all('p')[5]).to have_content(server.scopes[0].leases[0].created_at)
      end
      it 'updated_at' do
        expect(page.all('p')[6]).to have_content(server.scopes[0].leases[0].updated_at)
      end
      it 'scope description' do
        expect(page.all('p')[7]).to have_content(server.scopes[0].description)
      end
      it 'scope server name' do
        expect(page.all('p')[8]).to have_content(server.name)
      end
    end
  end
end