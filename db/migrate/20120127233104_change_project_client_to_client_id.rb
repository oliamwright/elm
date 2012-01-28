class ChangeProjectClientToClientId < ActiveRecord::Migration
  def up
		remove_column :projects, :client
		add_column :projects, :client_id, :integer
  end

  def down
		remove_column :projects, :client_id
		add_column :projects, :client, :string
  end
end
