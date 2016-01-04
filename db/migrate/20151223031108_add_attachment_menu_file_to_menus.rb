class AddAttachmentMenuFileToMenus < ActiveRecord::Migration
  def self.up
    change_table :menus do |t|
      t.attachment :menu_file
    end
  end

  def self.down
    remove_attachment :menus, :menu_file
  end
end
