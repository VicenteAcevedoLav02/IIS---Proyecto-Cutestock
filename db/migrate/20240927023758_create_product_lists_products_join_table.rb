class CreateProductListsProductsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :product_lists, :products do |t|
      t.index :product_list_id
      t.index :product_id
    end
  end
end
