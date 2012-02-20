class AddMissingIndicesToTables < ActiveRecord::Migration
  def change
		add_index :log_events, [:project_id]
		add_index :permissions_roles, [:permission_id]
		add_index :permissions_roles, [:role_id]
		add_index :projects, [:owner_id]
		add_index :projects, [:client_id]
		add_index :questions, [:questionable_type, :questionable_id]
		add_index :role_memberships, [:user_id]
		add_index :role_memberships, [:role_id]
		add_index :role_memberships, [:project_id]
		add_index :stories, [:owner_id]
		add_index :stories, [:project_id]
		add_index :stories, [:sprint_id]
		add_index :sub_items, [:owner_id]
  end
end
