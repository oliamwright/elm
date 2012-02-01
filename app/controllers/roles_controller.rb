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

	def update
		@role = Role.find(params[:id])
		if @role
			respond_to do |format|
				if @role.update_attributes(params[:role])
					format.html { redirect_to_(@role, :notice => "Role '#{@role.internal_name}' updated.") }
					format.json { respond_with_bip(@role) }
				else
					format.html { }
					format.json { respond_with_bip_error(@role) }
				end
			end
		end
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
		flash[:notice] = "Granted '#{@permission.short_name.to_s}' for '#{@permission.scope.to_s}' to role '#{@role.name}'."
		redirect_to_last_page
	end

	def revoke_permission
		@role = Role.find(params[:id])
		@permission = Permission.find(params[:permission_id])
		@role.permissions.delete(@permission)
		flash[:notice] = "Revoked '#{@permission.short_name.to_s}' for '#{@permission.scope.to_s}' from role '#{@role.name}'."
		redirect_to_last_page
	end

end
