class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :logs, :user, :username
  end
end
