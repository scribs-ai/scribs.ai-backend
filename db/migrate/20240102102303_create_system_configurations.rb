class CreateSystemConfigurations < ActiveRecord::Migration[7.1]
  def change
    create_table :system_configurations do |t|
      t.string :key
      t.string :value
      t.text :description

      t.timestamps
    end
  end
end
