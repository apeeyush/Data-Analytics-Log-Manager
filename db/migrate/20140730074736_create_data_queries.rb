class CreateDataQueries < ActiveRecord::Migration
  def change
    create_table :data_queries do |t|
      t.json :content
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
