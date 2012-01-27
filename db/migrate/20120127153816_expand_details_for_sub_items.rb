class ExpandDetailsForSubItems < ActiveRecord::Migration
  def up
		change_column :sub_items, :description, :text
  end

  def down
		change_column :sub_items, :description, :string
  end
end
