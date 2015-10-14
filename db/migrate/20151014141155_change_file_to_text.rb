class ChangeFileToText < ActiveRecord::Migration
  def change
    change_column :log_spreadsheets, :file, :text
  end
end
