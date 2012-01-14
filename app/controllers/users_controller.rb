class UsersController < ApplicationController

	def index
		@users = User.all
	end

	def user_data
		@user = User.find(params[:id]) rescue nil
		if request.xhr?
			render :action => 'user_data', :layout => false
		end
	end

	def update
		@user = User.find(params[:id]) rescue nil
		if @user
			respond_to do |format|
				if @user.update_attributes(params[:user])
					format.html { redirect_to(@user, :notice => "User '#{@user.email}' updated.") }
					format.json { respond_with_bip(@user) }
				else
					format.html { }
					format.json { respond_with_bip(@user) }
				end
			end
		end
	end

	def show
		@user = User.find(params[:id])
		require_perm!(current_user.can?(:show, @user)) || return
		if @project
			render :action => 'show_project'
		else
			render :action => 'show'
		end
	end

	def assign_role
		@user = User.find(params[:id])
		require_perm!(current_user.can?(:assign_role, @user)) || return
	end

	def do_assign_role
		@user = User.find(params[:user_id])
		require_perm!(current_user.can?(:assign_role, @user)) || return
		@role = Role.find(params[:role_id])
		@user.roles << @role
		flash[:notice] = "#{@user.email} assigned global role '#{@role.name}'."
		redirect_to_last_page
	end

	def do_remove_role
		@user = User.find(params[:id])
		require_perm!(current_user.can?(:unassign_role, @user)) || return
		@role = Role.find(params[:role_id])
		@user.roles.delete(@role)
		flash[:notice] = "#{@user.email} unassigned global role '#{@role.name}'."
		redirect_to_last_page
	end

	def assign_project_role
		@user = User.find(params[:id]) rescue User.new
		require_perm!(current_user.can?(:assign_project_role, @user)) || return
	end

	def do_assign_project_role
		@user = User.find(params[:user_id])
		require_perm!(current_user.can?(:assign_project_role, @user)) || return
		@role = Role.find(params[:role_id])
		@project = Project.find(params[:project_id])
		rm = RoleMembership.new
		rm.user = @user
		rm.project = @project
		rm.role = @role
		rm.primary = params[:primary]
		if rm.save
			flash[:notice] = "#{@user.email} assigned role '#{@role.name}' for project '#{@project.name}'."
		else
			flash[:error] = "Role could not be assigned."
		end
		redirect_to_last_page
	end

	def do_remove_project_role
		@user = User.find(params[:id])
		require_perm!(current_user.can?(:unassign_project_role, @user)) || return
		@role = Role.find(params[:role_id])
		@project = Project.find(params[:project_id])
		@user.role_memberships.for_project(@project).select { |rm| rm.role == @role }.first.destroy
		redirect_to_last_page
	end

end
