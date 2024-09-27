class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.references :business, null: false, foreign_key: true
      t.integer :price

      t.timestamps
    end
  end
end
