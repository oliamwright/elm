class SubItemsController < ApplicationController
	before_filter :load_story

	def create
		@sub_item = SubItem.new
		@sub_item.story = @story
		@sub_item.owner = current_user
		@sub_item.status = SubItem::INITIAL_STATUS
		@sub_item.item_type = SubItem::DEFAULT_ITEM_TYPE
		@sub_item.save
		redirect_to_last_page
	end

	def update
		@sub_item = SubItem.find(params[:id]) rescue nil
		if @sub_item
			respond_to do |format|
				if params[:sub_item][:status]
					fs = @sub_item.status
					ts = params[:sub_item][:status]
					if !current_user.can?("from_#{fs}_to_#{ts}".to_sym, @sub_item)
						format.html { redirect_to(@sub_item, :notice => "sub_item '#{@sub_item.details}' not updated.") }
						format.json { respond_bip_error(@sub_item) }
					else
						if @sub_item.update_attributes(params[:sub_item])
							if fs != ts
								@st = StatusTransition.new
								@st.sub_item = @sub_item
								@st.user = current_user
								@st.from_status = fs
								@st.to_status = ts
								@st.save
							end
							format.html { redirect_to(@sub_item, :notice => "sub_item '#{@sub_item.details}' updated.") }
							format.json { respond_with_bip(@sub_item) }
						else
							format.html { }
							format.json { respond_with_bip(@sub_item) }
						end
					end
				else
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
	end

	def show
		@sub_item = SubItem.find(params[:id]) rescue nil
		render :partial => 'sub_items/item', :object => @sub_item
	end

	private

	def load_story
		@story = Story.find(params[:story_id]) rescue nil
	end

end
