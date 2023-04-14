class ModifyingReferenceOfUsers < ActiveRecord::Migration[6.1]
  def up
    change_column_null :users, :department_id, true
  end
  def down 
      change_column_null :users, :department_id, false
  end

end
