class SubItemsController < ApplicationController
	before_filter :load_story

	def create
		@sub_item = SubItem.new
		@sub_item.story = @story
		@sub_item.owner = current_user
		@sub_item.save
		redirect_to_last_page
	end

	def update
		@sub_item = SubItem.find(params[:id]) rescue nil
		if @sub_item
			respond_to do |format|
				if @sub_item.update_attributes(params[:sub_item])
					format.html { redirect_to(@sub_item, :notice => "sub_item '#{@sub_item.details}' updated.") }
					format.json { respond_with_bip(@sub_item) }
				else
					format.html { }
					format.json { respond_with_bip(@sub_item) }
				end
			end
		end
	end

	private

	def load_story
		@story = Story.find(params[:story_id]) rescue nil
	end

end
