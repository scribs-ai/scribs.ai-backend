class AddImageUrlToWorkspaces < ActiveRecord::Migration[7.1]
  def change
    add_column :workspaces, :image_url, :string
  end
end
