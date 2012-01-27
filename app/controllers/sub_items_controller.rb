class SubItemsController < ApplicationController
	before_filter :load_story
	skip_before_filter :assert_authority!, :only => [ :do_action ]

	def do_action
		action = params[:si_action]
		ids = params[:ids].split(/,/)
		unless action && !ids.empty?
			render :status => 500
		end
		items = ids.map { |id| SubItem.find(id) rescue nil }
		case action
			when "own"
				items.each do |item|
					if current_user.can?(:take_ownership, item)
						current_user.take_ownership!(item)
					end
				end
				render :text => ''
			when "approved"
				items.each do |item|
					if current_user.can?("from_#{item.status}_to_approved".to_sym, item)
						item.set_status!(:approved, current_user)
					end
				end
				render :text => ''
			when "completed"
				items.each do |item|
					if current_user.can?("from_#{item.status}_to_completed".to_sym, item)
						item.set_status!(:completed, current_user)
					end
				end
				render :text => ''
			when "dev"
				items.each do |item|
					if current_user.can?("from_#{item.status}_to_dev".to_sym, item)
						item.set_status!(:dev, current_user)
					end
				end
				render :text => ''
			when "waiting"
				items.each do |item|
					if current_user.can?("from_#{item.status}_to_waiting".to_sym, item)
						item.set_status!(:waiting, current_user)
					end
				end
				render :text => ''
			when "open"
				items.each do |item|
					if current_user.can?("from_#{item.status}_to_open".to_sym, item)
						item.set_status!(:open, current_user)
					end
				end
				render :text => ''
			when "ignore"
				items.each do |item|
					if current_user.can?("from_#{item.status}_to_ignored".to_sym, item)
						item.set_status!(:ignored, current_user)
					end
				end
				render :text => ''
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
		if params[:sub_item]
			@sub_item = SubItem.new(params[:sub_item])
		else
			@sub_item = SubItem.new
		end
		@sub_item.story = @story
		@sub_item.owner = current_user
		@sub_item.status = SubItem::INITIAL_STATUS
		@sub_item.item_type = SubItem::DEFAULT_ITEM_TYPE
		if @sub_item.save
			e = SubItemCreationEvent.new.init(current_user, @sub_item).save
		end
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
								@st = StatusTransitionEvent.new.init(current_user, @sub_item, fs, ts)
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
