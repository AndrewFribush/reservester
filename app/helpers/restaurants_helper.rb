module RestaurantsHelper
  def current_owner_owns_restaurant(restaurant)
    if current_owner && restaurant.owner == current_owner
      true
    else
      false
    end
  end
end
