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

    scenario 'a user can leave a only one review on restaurant' do
      add_restaurant
      click_link 'Review KFC'
      fill_in 'Thoughts', with: 'so so'
      select '3', from: 'Rating'
      click_button 'Leave Review'
      click_link 'Review KFC'
      expect(current_path).to eq restaurants_path
      expect(page).to have_content 'You have already reviewed this restaurant'
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
