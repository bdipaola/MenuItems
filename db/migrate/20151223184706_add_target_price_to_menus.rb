class AddTargetPriceToMenus < ActiveRecord::Migration
  def change
  	add_column :menus, :target_price, :string
  end
end
