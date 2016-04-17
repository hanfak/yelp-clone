require 'rails_helper'

describe Restaurant, type: :model do
  it { is_expected.to have_many :reviews }
  it { is_expected.to belong_to :user}

  it 'deletes reviews associated with it when deleted' do
    rest = Restaurant.create name: 'KFC'
    review  = rest.reviews.create(thoughts: 'Thought', rating: 2)
    rest.destroy
    expect(Review.all).to_not include review
  end

  it 'is not a valid name if less than 3 characters' do
    restaurant = Restaurant.new(name: 'kf')
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).to_not be_valid
  end

  it 'is not valid unless it has a unique name' do
    Restaurant.create(name: 'New Resto')
    restaurant = Restaurant.new(name: 'New Resto')
    expect(restaurant).to have(1).error_on(:name)
  end

  describe '#average_rating' do
    context 'no reviews' do
      it 'returns "N/A" when there are no reviews' do
        restaurant = Restaurant.create(name: 'The Ivy')
        expect(restaurant.average_rating).to eq 'N/A'
      end
    end

    context '1 review' do
      it 'returns that rating' do
        restaurant = Restaurant.create(name: 'The Ivy')
        restaurant.reviews.create(rating: 4)
        expect(restaurant.average_rating).to eq 4
      end
    end

    context 'multiple reviews' do
      it 'returns the average' do
        restaurant = Restaurant.create(name: 'The Ivy')
        restaurant.reviews.create(rating: 1)
        restaurant.reviews.create(rating: 5)
        expect(restaurant.average_rating).to eq 3
      end
    end
  end

end
