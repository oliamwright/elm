class DebtsController < ApplicationController

	def index
		@debts = current_user.debts
	end

	def show
		@debt = current_user.debts.find(params[:id])
	end
end
