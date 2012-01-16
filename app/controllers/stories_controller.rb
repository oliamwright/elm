class StoriesController < ApplicationController

	def create
		@story = Story.new(params[:story])
		@story.project = @project
		@story.owner = current_user
		if @story.save
			flash[:notice] = 'Story created.'
		else
			flash[:error] = 'Story could not be created.'
		end
		redirect_to_last_page
	end

end
