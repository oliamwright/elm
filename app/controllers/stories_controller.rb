class StoriesController < ApplicationController
	
	before_filter :load_sprint

	def create
		@story = Story.new(params[:story])
		@story.project = @project
		@story.sprint = @sprint if @sprint
		@story.owner = current_user
		if @story.save
			flash[:notice] = 'Story created.'
		else
			flash[:error] = 'Story could not be created.'
		end
		redirect_to_last_page
	end

	def update
		@story = Story.find(params[:id]) rescue nil
		if @story
			respond_to do |format|
				if @story.update_attributes(params[:story])
					format.html { redirect_to(@story, :notice => "story '#{@story.details}' updated.") }
					format.json { respond_with_bip(@story) }
				else
					format.html { }
					format.json { respond_with_bip(@story) }
				end
			end
		end
	end

	def show
		@story = Story.find(params[:id]) rescue nil
		render :partial => 'stories/story', :object => @story
	end

	def pull
		
	end

	def push

	end

	private
	
	def load_sprint
		@sprint = Sprint.find(params[:sprint_id]) rescue nil
	end
end
