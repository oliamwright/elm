class AddTagsTransactionsIndices < ActiveRecord::Migration
  def self.up
		add_index :tags_transactions, :tag_id
		add_index :tags_transactions, :transaction_id
		add_index :tags_transactions, [:tag_id, :transaction_id]
  end

  def self.down
		remove_index :tags_transactions, :tag_id
		remove_index :tags_transactions, :transaction_id
		remove_index :tags_transactions, [:tag_id, :transaction_id]
  end
end
