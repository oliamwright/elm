class RolesController < ApplicationController

	def index
		@roles = Role.all
	end

	def show
		@role = Role.find(params[:id])
		require_perm!(current_user.can?(:show, @role)) || return
	end

	def grant
		@role = Role.find(params[:id])
		@permission = Permission.new
	end

	def grant_permission
		@role = Role.find(params[:id])
		@permission = Permission.find(params[:permission_id])
		@role.permissions << @permission
		redirect_to @role
	end

	def revoke_permission
		@role = Role.find(params[:id])
		@permission = Permission.find(params[:permission_id])
		@role.permissions.delete(@permission)
		redirect_to @role
	end

end
