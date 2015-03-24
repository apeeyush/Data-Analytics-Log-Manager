class SetHstoreColumnsNotNull < ActiveRecord::Migration
  def change
    columns = ['parameters', 'extras']

    reversible do |dir|
      dir.up do
        columns.each do |column|
          # Turn NULL hstore fields into empty hstores          
          execute "UPDATE logs SET #{column} = '' WHERE #{column} IS NULL"
          # here, '' means an empty hstore
          change_column_default(:logs, column, '')
        end
      end
      
      dir.down do
        columns.each do |column|
          # Turn empty hstores back into NULL columns
          # Oddly, array_length(akeys(...), 1) is NULL, not 0, when there are no hstore keys
          execute "UPDATE logs SET #{column} = NULL WHERE array_length(akeys(#{column}), 1) IS NULL"
          change_column_default(:logs, column, nil)
        end
      end
    end

    # Add NOT NULL constraint to hstore columns. Automatically reversible.
    change_column_null(:logs, :parameters, false)
    change_column_null(:logs, :extras, false)
  end
end
