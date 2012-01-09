class PermissionsController < ApplicationController

	skip_before_filter :assert_authority!

	def unscoped
		@permissions = Permission.order('scope asc, short_name asc')
		if request.xhr?
			render :action => 'unscoped', :layout => false
			return
		end
	end

	def for_scope
		scope = params[:scope]
		@permissions = Permission.order('short_name asc').find_all_by_scope(scope)
		if request.xhr?
			render :action => 'for_scope', :layout => false
			return
		end
	end

end
