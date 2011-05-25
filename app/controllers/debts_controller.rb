class DebtsController < ApplicationController

	def index
		@debts = current_user.debts
	end

end
