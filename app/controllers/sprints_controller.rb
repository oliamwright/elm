class SprintsController < ApplicationController
	
	def index
	end

	def show
		@sprint = Sprint.find(params[:id]) rescue nil
	end

end
