class AddAccountIndices < ActiveRecord::Migration
  def self.up
		add_index :accounts, :user_id
		add_index :accounts, :name
  end

  def self.down
		remove_index :accounts, :user_id
		remove_index :accounts, :name
  end
end
