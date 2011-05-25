class DebtsController < ApplicationController

	def index
		@debts = current_user.debts
	end

	def show
		@debt = current_user.debts.find(params[:id])
	end

	def new
		@debt = Debt.new
		@debt.service_date = DateTime.now
	end

	def create
		@debt = Debt.new(params[:debt])
		@debt.user = current_user
		@debt.save
		flash[:notice] = "Debt '#{@debt.name}' created"
		redirect_to @debt
	end

end
