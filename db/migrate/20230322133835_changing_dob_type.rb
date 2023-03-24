class ChangingDobType < ActiveRecord::Migration[6.1]
  def up
    change_column :users, :dob, :date
  end

  def down
    change_column :users, :dob, :datetime
  end
end
