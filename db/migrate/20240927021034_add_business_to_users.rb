class AddBusinessToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :business, null: false, foreign_key: true
  end
end
