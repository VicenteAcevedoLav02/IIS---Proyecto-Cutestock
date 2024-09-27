class CreateSupplyLists < ActiveRecord::Migration[7.0]
  def change
    create_table :supply_lists do |t|
      t.references :product, null: false, foreign_key: true # Relacionado con el producto
      t.timestamps
    end

    # Tabla intermedia para la relación muchos a muchos entre SupplyList y Supply
    create_table :supply_list_supplies do |t|
      t.references :supply_list, null: false, foreign_key: true
      t.references :supply, null: false, foreign_key: true
      t.timestamps
    end
  end
end