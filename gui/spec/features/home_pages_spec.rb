require 'rails_helper'

RSpec.describe "HomePages", type: :feature do
  describe "GET /home_pages" do
    describe 'Base home page' do
      before(:each) do
        visit '/home_pages'
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

      it 'should take you to the r2d2 home page when clicking the link' do
        click_link('Go to r2d2 Home')
        expect(current_path).to eq('/home_pages/r2d2')
      end
    end
  end
end
