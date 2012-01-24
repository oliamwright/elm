class TaskOwnershipsController < ApplicationController

	def update
		@task_ownership = TaskOwnership.find(params[:id]) rescue nil
		if @task_ownership
			respond_to do |format|
				if @task_ownership.update_attributes(params[:task_ownership])
					format.html { redirect_to(@task_ownership) }
					format.json { respond_with_bip(@task_ownership) }
				else
					format.html { }
					format.json { respond_with_bip(@task_ownership) }
				end
			end
		end
	end

end
