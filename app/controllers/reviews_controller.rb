class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
    if current_user.has_reviewed? @restaurant
      flash[:notice] = 'You have already reviewed this restaurant'
      redirect_to restaurants_path
    end
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.create(review_params)
    @review.update(user_id: current_user.id)
    redirect_to restaurants_path
  end

  def destroy
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.find(params[:id])
    unless  current_user.has_reviewed? @restaurant
      flash[:notice] = 'You cannot delete this review'
      return redirect_to restaurants_path
    end
    @review.destroy
    redirect_to restaurants_path
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end
end
