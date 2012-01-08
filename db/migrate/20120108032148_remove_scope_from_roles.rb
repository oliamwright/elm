class RemoveScopeFromRoles < ActiveRecord::Migration
  def self.up
		remove_column :roles, :scope
  end

  def self.down
		add_column :roles, :scope, :string
  end
end
