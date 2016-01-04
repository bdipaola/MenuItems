class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :name, null: false, limit: 50

      t.timestamps null: false
    end
  end
end
