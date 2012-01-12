class AddPrimaryFieldToRoleMemberships < ActiveRecord::Migration
  def self.up
		add_column :role_memberships, :primary, :boolean
  end

  def self.down
		remove_column :role_memberships, :primary
  end
end
