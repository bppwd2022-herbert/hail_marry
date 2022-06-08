class CreateRentals < ActiveRecord::Migration[6.1]
  def change
    create_table :rentals do |t|
      t.string :condition
      t.date :return_date
      t.date :estimate_return_date
      t.date :rented_date
      t.references :rentable, polymorphic: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
