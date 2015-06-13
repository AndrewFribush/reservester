class Restaurant < ActiveRecord::Base
  belongs_to :owner
  has_many :reservations

  validates_presence_of :name, :description, :address, :phone_number
end
