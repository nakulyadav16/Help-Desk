class ChangingContactType < ActiveRecord::Migration[6.1]
  def up
    change_column :users, :contact, :bigint
  end

  def down
    change_column :users, :contact, :integer
  end
end
