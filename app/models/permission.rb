class Permission < ActiveRecord::Base
	include PermissionCan
	include PermissionPermissions

	has_and_belongs_to_many :roles

	def detail_string
		self.long_description
	end

	def self.all_scopes
		Permission.all.map { |p| p.scope }.uniq.sort
	end

end
