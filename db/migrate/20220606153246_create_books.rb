class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.integer :isbn_number
      t.string :title
      t.string :author
      t.text :notes
      t.string :teacher
      t.string :name

      t.timestamps
    end
  end
end
