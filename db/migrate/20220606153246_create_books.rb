class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.integer :isbn_number
      t.string :title
      t.text :notes
      t.string :teacher

      t.timestamps
    end
  end
end
