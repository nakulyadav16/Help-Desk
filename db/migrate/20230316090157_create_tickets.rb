class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.string :subject
      t.string :description
      t.date :due_date
      t.string :priority
      t.references :assigned_to , null: false 
      t.references :creator, null: false
      t.references :department, null: false, foreign_key: true

      t.timestamps
    end

    add_foreign_key :tickets, :users, column: :assigned_to_id
    add_foreign_key :tickets, :users, column: :creator_id

  end
end
