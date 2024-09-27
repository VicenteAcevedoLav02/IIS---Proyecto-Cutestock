class CreateSupplyListsSuppliesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :supply_lists, :supplies do |t|
      t.index :supply_list_id
      t.index :supply_id
    end
  end
end
