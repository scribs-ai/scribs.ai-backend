class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.string :title
      t.text :content
      t.datetime :sent_at

      t.timestamps
    end
  end
end
