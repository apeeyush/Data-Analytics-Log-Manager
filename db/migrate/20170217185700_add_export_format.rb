class AddExportFormat < ActiveRecord::Migration
  def change
    add_column :log_spreadsheets, :format, :string, :default => "csv", :null => false
  end
end
