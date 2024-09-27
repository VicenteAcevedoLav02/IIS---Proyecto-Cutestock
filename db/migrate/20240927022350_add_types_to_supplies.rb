class AddTypesToSupplies < ActiveRecord::Migration[7.1]
  def change
    add_column :supplies, :tipo1, :string
    add_column :supplies, :tipo2, :string
    add_column :supplies, :tipo3, :string
  end
end
