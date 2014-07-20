class CreateJoinTableUserApplication < ActiveRecord::Migration
  def change
    create_join_table :users, :applications do |t|
      # t.index [:user_id, :application_id]
      # t.index [:application_id, :user_id]
    end
  end
end
