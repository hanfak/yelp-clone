require 'rails_helper'

describe User do

  it { is_expected.to have_many :restaurants }
  it { should have_many :reviews }
  it { is_expected.to have_many :reviewed_restaurants }

  # it 'checks if current user has already reviewed a restaurant' do
  #   add_restaurant
  #
  #   expect(click_link 'Review KFC').to
  # end
end
