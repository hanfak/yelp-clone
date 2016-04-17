require 'rails_helper'

feature 'reviewing' do
  include RestaurantHelpers

  context 'logged in' do
    scenario 'allows user to leave a review using a form' do
      add_restaurant
      visit '/restaurants'
      leave_review('So so', '3')
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content 'So so'
    end

    scenario 'a user can leave a only one review on restaurant' do
      add_restaurant
      leave_review('So so', '3')
      click_link 'Review KFC'
      expect(current_path).to eq restaurants_path
      expect(page).to have_content 'You have already reviewed this restaurant'
    end

    scenario 'user can delete a review' do
      add_restaurant
      leave_review('So so', '3')
      click_link 'Delete review'
      expect(page).not_to have_content 'So so'
      expect(current_path).to eq restaurants_path
    end

    scenario 'user can only delete their review' do
      add_restaurant
      leave_review('So so', '3')
      click_link 'Sign out'
      sign_up_again
      visit '/restaurants'
      click_link 'Delete review'
      expect(page).to have_content 'So so'
      expect(page).to have_content 'You cannot delete this review'
      expect(current_path).to eq restaurants_path
    end

    scenario 'displays an average rating for all reviews' do
      add_restaurant
      leave_review('So so', '3')
      click_link 'Sign out'
      sign_up_again
      visit '/restaurants'
      leave_review('Great', '5')
      expect(page).to have_content('Average rating: ★★★★☆')
    end
  end

  context 'Not logged in' do
    before { Restaurant.create name: 'KFC' }

    scenario "should not let someone leave a review" do
      visit '/restaurants'
      click_link 'Review KFC'
      expect(page).to have_content 'Log in'
    end
  end
end
