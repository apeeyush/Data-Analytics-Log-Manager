class AddNameToDataQueries < ActiveRecord::Migration
  def change
    add_column :data_queries, :name, :string
  end
end
