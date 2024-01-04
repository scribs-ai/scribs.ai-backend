class CreateWorkspaces < ActiveRecord::Migration[7.1]
  def change
    create_table :workspaces do |t|
      t.string :name
      t.boolean :archived
      t.datetime :archived_at

      t.timestamps
    end
  end
end
