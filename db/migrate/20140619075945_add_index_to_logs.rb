class AddIndexToLogs < ActiveRecord::Migration
  def change
    add_index :logs, :username
    add_index :logs, :time
    add_index :logs, :application
    add_index :logs, :activity
    add_index :logs, :event
    add_index :logs, :session
  end
end
