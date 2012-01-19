class AlterTypeColumnToItemType < ActiveRecord::Migration
  def up
		rename_column :sub_items, :type, :item_type
  end

  def down
		rename_column :sub_items, :item_type, :type
  end
end
