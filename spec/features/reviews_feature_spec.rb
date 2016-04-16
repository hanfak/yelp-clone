require 'rails_helper'

feature 'reviewing' do
  include RestaurantHelpers

  before { Restaurant.create name: 'KFC' }

  context 'logged in' do
    scenario 'allows user to leave a review using a form' do
      sign_up
      visit '/restaurants'
      leave_review
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content 'so so'
    end

    scenario 'a user can leave a only one review on restaurant' do
      add_restaurant
      leave_review
      click_link 'Review KFC'
      expect(current_path).to eq restaurants_path
      expect(page).to have_content 'You have already reviewed this restaurant'
    end

    scenario 'user can delete a review' do
      add_restaurant
      leave_review
      click_link 'Delete review'
      expect(page).not_to have_content 'so so'
      expect(current_path).to eq restaurants_path
    end

    scenario 'user can only delete their review' do
      add_restaurant
      leave_review
      click_link 'Sign out'
      sign_up_again
      visit '/restaurants'
      click_link 'Delete review'
      expect(page).to have_content 'so so'
      expect(page).to have_content 'You cannot delete this review'
      expect(current_path).to eq restaurants_path
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
