class CreateContents < ActiveRecord::Migration[7.1]
  def change
    create_table :contents do |t|
      t.string :title
      t.text :body
      t.string :image_url
      t.datetime :published_at

      t.timestamps
    end
  end
end
