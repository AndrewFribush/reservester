class OwnersController < ApplicationController

  def dashboard
    return redirect_to restaurants_path unless current_owner

    @restaurants = Restaurant.where owner_id: current_owner.id
  end
end
