class AddAasmToTickets < ActiveRecord::Migration[6.1]
  def change
    add_column :tickets, :aasm_state, :string
  end
end
