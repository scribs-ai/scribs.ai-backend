class RenameNameAndAddLastNameToUsers < ActiveRecord::Migration[7.1]
  def change
    # Change column name from 'name' to 'first_name'
    rename_column :users, :name, :first_name

    # Add new column 'last_name'
    add_column :users, :last_name, :string
  end
end
