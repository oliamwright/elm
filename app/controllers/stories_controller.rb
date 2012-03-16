class StoriesController < ApplicationController
	
	before_filter :load_sprint

	def do_action
		action = params[:si_action]
		ids = params[:ids].split(/,/)
		unless action && !ids.empty?
			render :status => 500
		end
		items = ids.map { |id| Story.find(id) rescue nil }
		@sprint = Sprint.find(params[:new_sprint_id]) rescue nil
		case action
			when "move"
				items.each do |item|
					if @sprint
						old_sprint = item.sprint
						item.sprint = @sprint
						item.number = 99999
						item.save
						if old_sprint
							old_sprint.renumber!
						else
							item.project.renumber_backlog!
						end
					end
				end
				@sprint.renumber!
				render :action => :move, :layout => false
			when "delete"
				items.each do |item|
					if current_user.can?(:delete, item)
						item.destroy
					end
				end
				render :text => ''
			else
				render :status => 500
		end
	end

	def create
		@story = Story.new(params[:story])
		@story.project = @project
		@story.sprint = @sprint if @sprint
		@story.owner = current_user
		if @story.save
			e = UserStoryCreationEvent.new.init(current_user, @story).save
			flash[:notice] = 'Story created.'
		else
			flash[:error] = 'Story could not be created.'
		end
		if request.xhr?
			render :partial => 'story', :object => @story, :layout => false
		else
			redirect_to_last_page
		end
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
		@story = Story.find(params[:id]) rescue nil
		if @story && @story.can_pull?
			@story.pull!
		end
		render :action => 'pull', :layout => false
	end

	def push
		@story = Story.find(params[:id]) rescue nil
		if @story && @story.can_push?
			@story.push!
		end
		render :action => 'pull', :layout => false
	end

	private
	
	def load_sprint
		@sprint = Sprint.find(params[:sprint_id]) rescue nil
	end
end
