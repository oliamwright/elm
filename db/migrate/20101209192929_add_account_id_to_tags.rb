class AddAccountIdToTags < ActiveRecord::Migration
  def self.up
		add_column :tags, :account_id, :integer
  end

  def self.down
		remove_column :tags, :account_id
  end
end
