require 'rails_helper'

RSpec.describe 'r2d2', type: :feature do
  before(:all) do
    Lease.all.destroy_all
    Device.all.destroy_all
    Scope.all.destroy_all
    Server.all.destroy_all
    @server = FactoryGirl.create(:server, scope_count: 1)
  end
  after(:all) do
    Lease.all.destroy_all
    Device.all.destroy_all
    Scope.all.destroy_all
    Server.all.destroy_all
  end
  describe 'GET /r2d2' do
    before(:each) do
      visit '/r2d2'
    end
    it 'has the program name as the title' do
      expect(page).to have_title('Remote Rogue Device Detector')
    end
    it 'has a link to Lists' do
      expect(page).to have_link('Lists', lists_path)
    end
    it 'has a link r2d2 to root' do
      expect(page).to have_link('Remote Rogue Device Detector', :href => '/r2d2')
    end
    it 'has Home as the page description in the navbar' do
      expect(page.all('.navbar')[0]).to have_content('Home')
    end
    it 'has link to l2s2' do
      expect(page).to have_link('l2s2', :href => '/l2s2')
    end
    it 'takes you to the l2s2 home page when clicking the l2s2 link' do
      #click_link('l2s2')
      #expect(current_path).to eq('/l2s2')
    end
    it 'displays a table' do
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
      describe 'data row' do
        it 'should have a link to display the details' do
          expect(page.find_link(@server.scopes[0].leases[0].device.mac, "/leases/#{@server.scopes[0].leases[0].id}"))
        end
        describe 'status column displays' do
          it 'a thumbs up icon if on the whitelist' do
            @server.scopes[0].leases[0].device.list = List.find_by_name('Whitelist')
            @server.scopes[0].leases[0].device.save
            visit '/r2d2'
            within(page.all('a.dropdown-toggle')[0]) do
              element = all('span')[0]
              expect(element['class']).to match(/glyphicon-thumbs-up/)
              expect(element['class']).to match(/text-success/)
            end
          end
          it 'a thumbs down icon if on the blacklist' do
            @server.scopes[0].leases[0].device.list = List.find_by_name('Blacklist')
            @server.scopes[0].leases[0].device.save
            visit '/r2d2'
            within(page.all('a.dropdown-toggle')[0]) do
              element = all('span')[0]
              expect(element['class']).to match(/glyphicon-thumbs-down/)
              expect(element['class']).to match(/text-danger/)
            end
          end
          it 'an unchecked square if not on either list' do
            @server.scopes[0].leases[0].device.list = List.find_by_name('Unassigned')
            @server.scopes[0].leases[0].device.save
            visit '/r2d2'
            within(page.all('a.dropdown-toggle')[0]) do
              element = all('span')[0]
              expect(element['class']).to match(/glyphicon-unchecked/)
            end
          end
          describe 'clicking the glyphicon to display the dropdown' do
            it 'displays the selections' do
              @server.scopes[0].leases[0].device.list = List.find_by_name('Unassigned')
              @server.scopes[0].leases[0].device.save
              visit '/r2d2'
              link_id = @server.scopes[0].leases[0].id.to_s
              find("#L#{link_id}").click
              within(page.all('ul.dropdown-menu')[0]) do
                i = 0
                List.all.each do |l|
                  expect(all('li')[i]).to have_content(l.name)
                  i = i+1
                end
              end
            end
            it ' and selecting "Blacklist"' do
              @server.scopes[0].leases[0].device.list = List.find_by_name('Unassigned')
              @server.scopes[0].leases[0].device.save
              visit '/r2d2'
              link_id = @server.scopes[0].leases[0].id.to_s
              find("#L#{link_id}").click
              within(page.all('ul.dropdown-menu')[0]) do
                click_link('Blacklist')
              end
              @server.reload
              expect(@server.scopes[0].leases[0].device.list).to eq(List.find_by_name('Blacklist'))
            end
            it 'and selecting "Whitelist"' do
              @server.scopes[0].leases[0].device.list = List.find_by_name('Unassigned')
              @server.scopes[0].leases[0].device.save
              visit '/r2d2'
              link_id = @server.scopes[0].leases[0].id.to_s
              find("#L#{link_id}").click
              within(page.all('ul.dropdown-menu')[0]) do
                click_link('Whitelist')
              end
              @server.reload
              expect(@server.scopes[0].leases[0].device.list).to eq(List.find_by_name('Whitelist'))
            end
            it 'and selecting "Unassigned"' do
              @server.scopes[0].leases[0].device.list = List.find_by_name('Whitelist')
              @server.scopes[0].leases[0].device.save
              visit '/r2d2'
              link_id = @server.scopes[0].leases[0].id.to_s
              find("#L#{link_id}").click
              within(page.all('ul.dropdown-menu')[0]) do
                click_link('Unassigned')
              end
              @server.reload
              expect(@server.scopes[0].leases[0].device.list).to eq(List.find_by_name('Unassigned'))
            end
          end
          describe 'a fingerprint icon' do
            it 'with a checkmark if all fingerprint fields are set'
            it 'with an x if not all the fingerprint fields are set'
            it 'with an i if hovered over'
          end
        end
        it 'should have DHCP name' do
          expect(page.all('td')[2]).to have_content(@server.scopes[0].leases[0].name)
        end
        it 'displaying the IP' do
          expect(page.all('td')[3]).to have_content(@server.scopes[0].leases[0].ip)
        end
        it 'displaying the lease expiration datetime' do
          expect(page.all('td')[4]).to have_content(@server.scopes[0].leases[0].expiration)
        end
      end
    end
    describe 'has pagination controls when table has more than 10 rows' do
      before(:each) do
        10.times  { @server.scopes[0].leases << FactoryGirl.create(:lease) }
        visit '/r2d2'
      end
      it do
        expect(page).to have_selector('div.pagination')
      end
    end
  end
  describe 'clicking a DHCP MAC link' do
    before(:each) do
      visit '/r2d2'
      click_link "#{@server.scopes[0].leases[0].device.mac}"
    end
    it 'takes you to /leases/:id' do
      expect(current_path).to eq("/leases/#{@server.scopes[0].leases[0].id}")
    end
    it 'displays the lease MAC in the description in the navbar' do
      expect(page.all('.navbar-text')[0]).to have_content(@server.scopes[0].leases[0].device.mac)
    end
    describe 'displays the device' do
      it 'list' do
        expect(page.all('.row')[0]).to have_content(@server.scopes[0].leases[0].device.list.name)
      end
      it 'notes' do
        @server.scopes[0].leases[0].device.notes = 'This is a test'
        @server.scopes[0].leases[0].device.save!
        visit '/r2d2'
        click_link "#{@server.scopes[0].leases[0].device.mac}"
        expect(find_field('device_notes').value).to eq('This is a test')
      end
      it 'fingerprint'
      it 'model'
      it 'purpose'
      it 'department'
      it 'owner'
    end
    describe ', filling in the Notes textarea and clicking the Edit button' do
      it 'displays the new notes' do
        fill_in('device_notes', :with => 'This is NOT a test')
        click_button('Update Notes')
        expect(find_field('device_notes').value).to eq('This is NOT a test')
      end
    end
    describe 'displays the lease' do
      it 'name' do
        expect(page.all('p')[1]).to have_content(@server.scopes[0].leases[0].name)
      end
      it 'IP' do
        expect(page.all('p')[1]).to have_content(@server.scopes[0].leases[0].ip)
      end
      it 'mask' do
        expect(page.all('p')[1]).to have_content(@server.scopes[0].leases[0].mask)
      end
      it 'expiration' do
        expect(page.all('p')[2]).to have_content(@server.scopes[0].leases[0].expiration)
      end
      it 'scope description' do
        expect(page.all('p')[2]).to have_content(@server.scopes[0].description)
      end
      it 'scope server name' do
        expect(page.all('p')[2]).to have_content(@server.name)
      end
      it 'kind' do
        expect(page.all('p')[3]).to have_content(@server.scopes[0].leases[0].kind)
      end
      it 'created_at' do
        expect(page.all('p')[3]).to have_content(@server.scopes[0].leases[0].created_at)
      end
      it 'updated_at' do
        expect(page.all('p')[3]).to have_content(@server.scopes[0].leases[0].updated_at)
      end
    end
  end
  describe 'footer' do
    before(:each) { visit '/r2d2' }
    it 'should be scoped to the footer element'
    it 'displays fingerprint font attribution' do
      expect(page).to have_link('flaticon.com', :href => 'http://www.flaticon.com')
      expect(page).to have_link('CC BY', :href => 'http://creativecommons.org/licenses/by/3.0/')
      expect(page).to have_link('Freepik', :href => 'http://www.freepik.com')
    end
    it 'displays glyphicon attribtion' do
      expect(page).to have_link('GLYPHICONS Halflings', :href => 'http://glyphicons.com/')
    end
    it 'displays Twitter Bootstrap attribtion' do
      expect(page).to have_link('Twitter Bootstrap', :href => 'http://getbootstrap.com/')
    end
  end
end