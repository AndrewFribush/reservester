class AddRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name,         null: false
      t.string :description,  null: false
      t.string :address,      null: false
      t.string :phone_number, null: false

      t.timestamps
    end
  end
end
