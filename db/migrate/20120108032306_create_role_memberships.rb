class CreateRoleMemberships < ActiveRecord::Migration
  def self.up
    create_table :role_memberships do |t|
      t.references :user
      t.references :role
      t.references :project

      t.timestamps
    end
  end

  def self.down
    drop_table :role_memberships
  end
end
