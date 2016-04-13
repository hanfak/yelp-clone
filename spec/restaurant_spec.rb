require 'rails_helper'

describe Restaurant, type: :model do
  it { is_expected.to have_many :reviews }
  
  it 'deletes reviews associated with it when deleted' do
    rest = Restaurant.create name: 'KFC'
    review  = rest.reviews.create(thoughts: 'Thought', rating: 2)
    rest.destroy
    expect(Review.all).to_not include review
  end
end
