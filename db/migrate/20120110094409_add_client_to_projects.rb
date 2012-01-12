class AddClientToProjects < ActiveRecord::Migration
  def self.up
		add_column :projects, :client, :string
  end

  def self.down
		remove_column :projects, :client
  end
end
