class AddNombreToSupplies < ActiveRecord::Migration[7.1]
  def change
    add_column :supplies, :name, :string
  end
end
