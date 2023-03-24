class CreateTicketHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :ticket_histories do |t|
      t.references :ticket, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
