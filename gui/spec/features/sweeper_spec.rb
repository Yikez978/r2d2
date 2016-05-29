require 'rails_helper'

RSpec.describe "l2s2 sweeper", type: :feature do
  describe 'Get /sweepers/:id' do
    let!(:sweeper) { FactoryGirl.create(:sweeper) }
    before(:each) { visit "/sweepers/#{sweeper.id}" }
    it 'has the sweeper description in the navbar' do
      expect(page.all('.navbar-text')[0]).to have_content(sweeper.description)
    end
    describe 'table' do
      it 'should be sortable by MAC'
      it 'should be sortable by IP'
      describe 'headings' do
        it 'has thead' do
          expect(page).to have_selector('thead')
        end
        it 'has a Sweep column' do
          expect(page.all('th')[0]).to have_content('Sweep')
        end
        it 'has a Timestamp column' do
          expect(page.all('th')[1]).to have_content('Timestamp')
        end
        it 'has a Node Count column' do
          expect(page.all('th')[2]).to have_content('Node Count')
        end
      end
      describe 'data row' do
        let!(:sweep) { FactoryGirl.create(:sweep) }
        before(:each) do
          sweep.nodes << FactoryGirl.create(:node, mac: sweeper.mac)
          visit "/sweepers/#{sweeper.id}"
        end
        it 'has a link to display the sweep details' do
          expect(page.find_link(sweep.description,"/sweep/#{sweep.id}"))
        end
        it 'should display the sweep descriptions' do
          expect(page.all('td')[0]).to have_content(sweep.description)
        end
        it 'should display the Timestamp' do
          expect(page.all('td')[1]).to have_content(sweep.created_at)
        end
        it 'should display the Node Count' do
          expect(page.all('td')[2]).to have_content(sweep.nodes.count)
        end
      end
    end
  end
  describe 'Clicking description of a /sweepers/:id item' do
    let!(:sweeper) { FactoryGirl.create(:sweeper) }
    let!(:sweep) { FactoryGirl.create(:sweep) }
    before(:each) do
      sweep.nodes << FactoryGirl.create(:node, mac: sweeper.mac)
      visit "/sweepers/#{sweeper.id}"
      click_link(sweep.description)
    end
    it 'should go to /sweeps/:id' do
      expect(current_path).to eq("/sweeps/#{sweep.id}")
    end
    it 'should have the sweep description in the description in the navbar' do
      expect(page.all('.navbar-text')[0]).to have_content(sweep.description)
    end
    describe 'table' do
      describe 'headings' do
        it 'should have MAC' do
          expect(page.all('th')[0]).to have_content('MAC')
        end
        it 'should have IP' do
          expect(page.all('th')[1]).to have_content('IP')
        end
      end
      describe 'data row' do
        it 'should display the node MAC' do
          expect(page.all('td')[0]).to have_content(sweep.nodes[0].mac)
        end
        it 'should display the node IP' do
          expect(page.all('td')[1]).to have_content(sweep.nodes[0].ip)
        end
        # the next test is bad - passes when it shouldn't
        # need to create multiple sweeps and devices?
        it 'should have a link to a node' do
          expect(page.find_link(sweep.nodes[0].mac,"/nodes/#{sweep.nodes[0].id}"))
        end
      end
    end
  end
end