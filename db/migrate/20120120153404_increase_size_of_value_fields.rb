class IncreaseSizeOfValueFields < ActiveRecord::Migration
  def up
		change_column :projects, :value, :text
		change_column :projects, :goal, :text
		change_column :projects, :roi, :text
  end

  def down
		change_column :projects, :value, :string
		change_column :projects, :goal, :string
		change_column :projects, :roi, :string
  end
end
