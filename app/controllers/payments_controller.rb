class PaymentsController < ApplicationController

	before_filter :load_debt, :only => [:new, :create]

	def index
	end

	def show
	end

	def new
		@payment = Payment.new
		@payment.debt = @debt
	end

	def create
		ed = Date.new(params[:payment]["event_date(1i)"].to_i, params[:payment]["event_date(2i)"].to_i, params[:payment]["event_date(3i)"].to_i).to_datetime
		params[:payment].delete_if { |k,v| k =~ /^event_date/ }
		puts params.inspect
		@payment = Payment.new(params[:payment])
		@payment.debt = @debt
		@payment.save
		@payment.event_date = ed
		@payment.save
		flash[:notice] = "Payment applied to debt '#{@debt.name}'"
		redirect_to @debt
	end

	private

	def load_debt
		@debt = current_user.debts.find(params[:debt_id])
	end
end
