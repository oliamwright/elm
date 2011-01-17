class RemoveTagsTransactionsJoinTable < ActiveRecord::Migration
  def self.up
		drop_table :tags_transactions
  end

  def self.down
  end
end
