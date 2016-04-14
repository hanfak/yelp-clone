module RestaurantHelpers
  def sign_up
    visit '/'
    click_link('Sign up')
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'testtest'
    fill_in 'Password confirmation', with: 'testtest'
    click_button 'Sign up'
  end

  def sign_up_again
    visit '/'
    click_link('Sign up')
    fill_in 'Email', with: 'testagain@example.com'
    fill_in 'Password', with: 'testtest'
    fill_in 'Password confirmation', with: 'testtest'
    click_button 'Sign up'
  end

  def add_restaurant
    sign_up
    visit '/restaurants'
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'KFC'
    click_button 'Create Restaurant'
    visit '/restaurants'
  end
end
