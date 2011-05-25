class ChargesController < ApplicationController

	before_filter :load_debt, :only => [:new, :create]

	def index
	end

	def show
	end

	def new
		@charge = Charge.new
		@charge.debt = @debt
	end

	def create
		ed = Date.new(params[:charge]["event_date(1i)"].to_i, params[:charge]["event_date(2i)"].to_i, params[:charge]["event_date(3i)"].to_i).to_datetime
		params[:charge].delete_if { |k,v| k =~ /^event_date/ }
		puts params.inspect
		@charge = Charge.new(params[:charge])
		@charge.debt = @debt
		@charge.save
		@charge.event_date = ed
		@charge.save
		flash[:notice] = "Charge applied to debt '#{@debt.name}'"
		redirect_to @debt
	end

	private

	def load_debt
		@debt = current_user.debts.find(params[:debt_id])
	end
end
