class CreateWines < ActiveRecord::Migration
  def change
    create_table :wines do |t|
      t.string :title
      t.string :price
      t.string :price_sale
      t.string :company
      t.string :vintage
      t.string :varietal
      t.string :country
      t.string :region
      t.text :description
      t.string :sku
      t.text :image

      t.timestamps
    end
  end
end
