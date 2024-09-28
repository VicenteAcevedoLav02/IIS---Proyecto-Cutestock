class AddRequiresToSupply < ActiveRecord::Migration[7.1]
  def change
    add_column :supplies, :requires, :integer
  end
end
