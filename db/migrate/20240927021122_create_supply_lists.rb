class CreateSupplyLists < ActiveRecord::Migration[7.1]
  def change
    create_table :supply_lists do |t|
      t.references :product, null: false, foreign_key: true
      t.references :supply, foreign_key: true

      t.timestamps
    end
  end
end
