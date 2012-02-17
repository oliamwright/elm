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
			when "assign"
				user = User.find(params[:user_id])
				items.each do |item|
					if user.can?(:take_ownership, item) && current_user.can?(:assign_ownership, item)
						user.take_ownership!(item)
					end
				end
				render :text => ''
			when "own"
				items.each do |item|
					if current_user.can?(:take_ownership, item)
						current_user.take_ownership!(item)
					end
				end
				render :text => ''
			when "set_status"
				new_status = params[:new_status].gsub(/ /, '').underscore.downcase
				items.each do |item|
					if current_user.can?("from_#{item.status}_to_#{new_status}".to_sym, item)
						item.set_status!(new_status, current_user)
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
		redirect_to_last_page :anchor => "si_#{@sub_item.display_number}"
	end

	def update
		@sub_item = SubItem.find(params[:id]) rescue nil
		if @sub_item

			e = nil
			error = false

			if params[:sub_item][:item_type]
				ot = @sub_item.item_type
				nt = params[:sub_item][:item_type]
				if !(ot == nt)
					e = SubItemTypeChangeEvent.new.init(current_user, @sub_item, ot, nt)
				end
			elsif params[:sub_item][:status]
				fs = @sub_item.status
				ts = params[:sub_item][:status]
				if !current_user.can?("from_#{fs}_to_#{ts}".to_sym, @sub_item)
					error = true
				else
					if !(fs == ts)
						e = StatusTransitionEvent.new.init(current_user, @sub_item, fs, ts)
					end
				end
			end

			unless error
				if @sub_item.update_attributes(params[:sub_item])
					if !e.nil?
						e.save
					end
				else
					error = true
				end
			end

			respond_to do |format|
				if error
					format.html { redirect_to(@sub_item, :notice => "sub_item '#{@sub_item.details}' not updated.") }
					format.json { respond_with_bip_error(@sub_item) }
				else
					format.html { redirect_to(@sub_item, :notice => "sub_item '#{@sub_item.details}' updated.") }
					format.json { respond_with_bip(@sub_item) }
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
