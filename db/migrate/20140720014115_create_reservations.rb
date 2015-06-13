class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :email,          null: false
      t.datetime :requested_at, null: false
      t.integer :restaurant_id, null: false
      t.string :message

      t.foreign_key :restaurants, dependent: :delete
      t.timestamps
    end

  end
end
