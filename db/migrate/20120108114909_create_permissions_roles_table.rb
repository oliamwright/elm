class CreatePermissionsRolesTable < ActiveRecord::Migration
  def self.up
		create_table :permissions_roles, :id => false do |t|
			t.references :permission
			t.references :role
			t.timestamps
		end
  end

  def self.down
		drop_table :permissions_roles
  end
end
