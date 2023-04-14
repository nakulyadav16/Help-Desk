class AddAncestryToRole < ActiveRecord::Migration[6.1]
  def change
    add_column :roles, :ancestry, :string
    add_index :roles, :ancestry
  end
end
