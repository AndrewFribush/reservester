class RestaurantsController < ApplicationController
  include RestaurantsHelper

  before_filter :load_restaurant, only: [:show, :edit, :update, :destroy,
                                         :delete_reservation, :create_reservation]
  before_filter :authenticate_owner!, only: [:new, :create, :edit, :update, :destroy]
  before_filter :ensure_owner_owns_restaurant, only: [:edit, :update, :destroy]

  attr_reader :restaurant

  def index
    @restaurants = Restaurant.all
  end

  def show
  end

  def new
  end

  def create
    @restaurant = Restaurant.create(restaurant_params.merge(owner: current_owner))

    if @restaurant.errors.any?
      render new_restaurant_path
    else
      redirect_to @restaurant
    end
  end

  def edit
  end

  def update
    if @restaurant.update_attributes(restaurant_params)
      flash[:notice] = "Restaurant saved."
      redirect_to restaurant_path
    else
      render :edit
    end
  end

  def destroy
    @restaurant.destroy
    flash[:notice] = "Restaurant deleted."

    redirect_to restaurants_path
  end

  def delete_reservation
    begin
      reservation = Reservation.find(params[:reservation_id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Reservation not found"
      return redirect_to restaurant_path
    end

    if @restaurant.reservations.include? reservation
      reservation.destroy
      flash[:notice] = "Reservation marked as confirmed"
    else
      flash[:alert] = "Reservation not at this restaurant"
    end

    redirect_to restaurant_path
  end

  def create_reservation
    reservation = Reservation.create(
      email: reservation_params[:email],
      restaurant_id: @restaurant.id,
      requested_at: 1.day.from_now.to_datetime,
      message: reservation_params[:message]
    )

    if reservation.errors.any?
      flash[:alert] = "Problem creating reservation"
    else
      flash[:notice] = "Reservation created!"
    end

    redirect_to restaurant_path
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :address, :phone_number)
  end

  def reservation_params
    params.require(:reservation).permit(:email, :requested_at, :message)
  end

  def load_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def ensure_owner_owns_restaurant
    unless current_owner_owns_restaurant(@restaurant)
      flash[:alert] = "You can't edit restaurants you don't own"
      redirect_to restaurants_path
    end
  end
end
