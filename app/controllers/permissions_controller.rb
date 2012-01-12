class PermissionsController < ApplicationController

	skip_before_filter :assert_authority!

	def unscoped
		@role = Role.find(params[:role_id])
		@permissions = Permission.order('scope asc, short_name asc').select { |p| !@role.permissions.include?(p) }
		if request.xhr?
			render :action => 'unscoped', :layout => false
			return
		end
	end

	def for_scope
		scope = params[:scope]
		@role = Role.find(params[:role_id])
		@permissions = Permission.order('short_name asc').find_all_by_scope(scope).select { |p| !@role.permissions.include?(p) }
		if request.xhr?
			render :action => 'for_scope', :layout => false
			return
		end
	end

end
