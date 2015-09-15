class AddAllColumnsToExport < ActiveRecord::Migration
  def change
    add_column :log_spreadsheets, :all_columns, :boolean, :default => false, :null => false
  end
end
