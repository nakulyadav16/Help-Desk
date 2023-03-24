class AddReferenceToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :department, null: false, foreign_key: true
  end
end
