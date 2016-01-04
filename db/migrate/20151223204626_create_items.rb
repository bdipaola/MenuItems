class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :item_name
      t.string :price
      t.references :menu

      t.timestamps null: false
    end
  end
end
