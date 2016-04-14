require 'rails_helper'

  feature 'restaurants' do
    include RestaurantHelpers

    context 'no restaurants have been added' do
      scenario 'should display a prompt to add a restaurant' do
        sign_up
        visit '/restaurants'
        expect(page).to have_content 'No restaurants yet'
        expect(page).to have_link 'Add a restaurant'
      end
    end

    context 'restaurants have been added' do
      before { add_restaurant }

      scenario 'display restaurants' do
        expect(page).to have_content 'KFC'
        expect(page).not_to have_content 'No restaurants yet'
      end
    end

    context 'creating restaurants' do
      scenario 'prompt user to fill out a form; display the new restaurant' do
        add_restaurant
        expect(page).to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
      end
    end

    context 'viewing restaurants' do
      let!(:kfc) { Restaurant.create(name: 'KFC') }

      scenario 'lets a user view a restaurant' do
        visit '/restaurants'
        click_link 'KFC'
        expect(page).to have_content 'KFC'
        expect(current_path).to eq "/restaurants/#{kfc.id}"
      end
    end

    context 'editing restaurants' do
      before {  add_restaurant}

      scenario 'let a user edit a restaurant' do
        visit '/restaurants'
        click_link 'Edit KFC'
        fill_in 'Name', with: 'Kentucky Fried Chicken'
        click_button 'Update Restaurant'
        expect(page).to have_content 'Kentucky Fried Chicken'
        expect(current_path).to eq '/restaurants'
      end

      scenario 'does not allow a user to edit restaurants others have created' do
         click_link 'Sign out'
         sign_up_again
         visit '/restaurants'
         click_link 'Edit KFC'
         expect(current_path).to eq restaurants_path
         expect(page).to have_content 'You cannot edit this restaurant'
       end
    end

    context 'deleting restaurants' do
      before { add_restaurant }

      scenario 'can delete if not the user who created' do
        click_link 'Delete KFC'
        expect(page).not_to have_content 'KFC'
        expect(page).to have_content 'Restaurant deleted successfully'
      end

      scenario 'cannot delete if not the user who created' do
        click_link 'Sign out'
        sign_up_again
        click_link 'Delete KFC'
        expect(current_path).to eq restaurants_path
        expect(page).to have_content 'You cannot delete this restaurant'
      end
    end

    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        sign_up
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end

    context 'user signed in' do
      scenario 'does not have add restaurant link on index page' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        expect(page).to have_content 'Log in'
      end

      scenario 'has to sign in before accessing add a restaurant page' do
        visit '/restaurants/new'
        expect(page).to have_content 'Log in'
      end
    end
end
