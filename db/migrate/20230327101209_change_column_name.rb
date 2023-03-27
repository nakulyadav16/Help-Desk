class ChangeColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :tickets, :aasm_state, :status
  end
end
