class PhoneCallsController < ApplicationController

	before_filter :load_debt, :only => [:new, :create]

	def index
	end

	def show
	end

	def new
		@phone_call = PhoneCall.new
		@phone_call.debt = @debt
	end

	def create
		ed = merge_time_and_event_date(params[:phone_call]["event_date(1i)"].to_i, params[:phone_call]["event_date(2i)"].to_i, params[:phone_call]["event_date(3i)"].to_i)
		params[:phone_call].delete_if { |k,v| k =~ /^event_date/ }
		puts params.inspect
		@phone_call = PhoneCall.new(params[:phone_call])
		@phone_call.debt = @debt
		@phone_call.save
		@phone_call.event_date = ed
		@phone_call.save
		flash[:notice] = "Phone Call applied to debt '#{@debt.name}'"
		redirect_to @debt
	end

	private

	def load_debt
		@debt = current_user.debts.find(params[:debt_id])
	end
end
