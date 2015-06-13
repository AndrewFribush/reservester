class Reservation < ActiveRecord::Base
  belongs_to :restaurant

  validates_presence_of :email, :requested_at, :restaurant_id
end
