class CreatePrices < ActiveRecord::Migration[7.1]
  def change
    create_table :prices do |t|
      t.string :stripe_price_id
      t.timestamps
    end
  end
end
