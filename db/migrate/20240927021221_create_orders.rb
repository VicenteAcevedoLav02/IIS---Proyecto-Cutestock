class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :business, null: false, foreign_key: true
      t.string :name
      t.integer :price
      t.integer :production_cost
      t.integer :net_profit

      t.timestamps
    end
  end
end
