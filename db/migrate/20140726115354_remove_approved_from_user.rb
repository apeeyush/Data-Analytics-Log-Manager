class RemoveApprovedFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :approved
  end
end
