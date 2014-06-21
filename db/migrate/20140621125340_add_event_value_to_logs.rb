class AddEventValueToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :event_value, :string
  end
end
