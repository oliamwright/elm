class RolesController < ApplicationController

	def index
		@roles = Role.order("name asc").all
	end

	def new
		@role = Role.new
	end

	def create
		@role = Role.new(params[:role])
		if @role.save
			flash[:notice] = "Role '#{@role.name}' created."
		else
			flash[:error] = "Role '#{@role.name}' could not be created."
		end
		redirect_to roles_url
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
