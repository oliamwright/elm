class AddTagsIndices < ActiveRecord::Migration
  def self.up
		add_index :tags, :account_id
		add_index :tags, :name
  end

  def self.down
		remove_index :tags, :account_id
		remove_index :tags, :name
  end
end
