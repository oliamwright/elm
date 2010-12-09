class AddTransactionIndices < ActiveRecord::Migration
  def self.up
		add_index :transactions, :account_id
		add_index :transactions, :transaction_date
  end

  def self.down
		remove_index :transactions, :account_id
		remove_index :transactions, :transaction_date
  end
end
