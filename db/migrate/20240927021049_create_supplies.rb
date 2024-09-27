class CreateSupplies < ActiveRecord::Migration[7.1]
  def change
    create_table :supplies do |t|
      t.references :business, null: false, foreign_key: true
      t.integer :cost
      t.integer :stock

      t.timestamps
    end
  end
end
