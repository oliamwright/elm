class TagsController < ApplicationController
	before_filter :load_account, :only => [:index, :show]

	def index
		@tags = @account.tags.order("name asc").paginate :page => params[:page], :per_page => 25
	end

	def show
		@tag = @account.tags.find(params[:id])
	end
end
