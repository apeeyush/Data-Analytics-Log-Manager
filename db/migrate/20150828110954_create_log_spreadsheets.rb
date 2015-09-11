class CreateLogSpreadsheets < ActiveRecord::Migration
  def change
    create_table :log_spreadsheets do |t|
      t.integer :user_id
      t.string :status
      t.string :status_msg
      t.text :query
      t.binary :file

      t.timestamps
    end
  end
end
