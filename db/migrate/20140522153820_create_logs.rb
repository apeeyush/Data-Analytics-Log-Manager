class CreateLogs < ActiveRecord::Migration
  def change
    execute "CREATE EXTENSION hstore"
    create_table :logs do |t|
      t.string :session
      t.string :user
      t.string :application
      t.string :activity
      t.string :event
      t.datetime :time
      t.hstore :parameters
      t.hstore :extras

      t.timestamps
    end
  end
end
