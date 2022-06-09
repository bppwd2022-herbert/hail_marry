class CreateVans < ActiveRecord::Migration[6.1]
  def change
    create_table :vans do |t|
      t.integer :vyear
      t.string :vmake
      t.string :vmodel
      t.text :notes
      t.string :name
      t.timestamps
    end
  end
end
