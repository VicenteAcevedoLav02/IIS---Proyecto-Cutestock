class CreateProductLists < ActiveRecord::Migration[7.1]
  def change
    create_table :product_lists do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
