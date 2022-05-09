class CreateRentals < ActiveRecord::Migration[6.1]
  def change
    create_table :rentals do |t|
      t.string :condition
      t.date :return_date
      t.date :estimate_return_date
      t.date :rented_date
      t.references :user
      t.references :item
      t.timestamps
    end
  end
end
