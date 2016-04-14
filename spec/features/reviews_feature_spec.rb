require 'rails_helper'

feature 'reviewing' do
  include RestaurantHelpers

  before { Restaurant.create name: 'KFC' }

  context 'logged in' do
    scenario 'allows user to leave a review using a form' do
      sign_up
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in 'Thoughts', with: 'so so'
      select '3', from: 'Rating'
      click_button 'Leave Review'
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content 'so so'
    end
  end

  context 'Not logged in' do
    scenario "should not let someone leave a review" do
      visit '/restaurants'
      click_link 'Review KFC'
      expect(page).to have_content 'Log in'
    end
  end
end
