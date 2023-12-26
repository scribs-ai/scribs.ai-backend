class CreateUserAnalytics < ActiveRecord::Migration[7.1]
  def change
    create_table :user_analytics do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :time
      t.string :feature
      t.date :date
      t.integer :tokens

      t.timestamps
    end
  end
end
