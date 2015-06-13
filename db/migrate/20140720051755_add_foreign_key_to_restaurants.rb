class AddForeignKeyToRestaurants < ActiveRecord::Migration
  def change
    change_table :restaurants do |t|
      t.foreign_key :owners, dependent: :delete
    end
  end
end
