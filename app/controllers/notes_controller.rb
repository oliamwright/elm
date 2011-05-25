class NotesController < ApplicationController
	before_filter :load_debt, :only => [:new, :create]

	def index
	end

	def show
	end

	def new
		@note = Note.new
		@note.debt = @debt
	end

	def create
		ed = Date.new(params[:note]["event_date(1i)"].to_i, params[:note]["event_date(2i)"].to_i, params[:note]["event_date(3i)"].to_i).to_datetime
		params[:note].delete_if { |k,v| k =~ /^event_date/ }
		puts params.inspect
		@note = Note.new(params[:note])
		@note.debt = @debt
		@note.save
		@note.event_date = ed
		@note.save
		flash[:notice] = "Note applied to debt '#{@debt.name}'"
		redirect_to @debt
	end

	private

	def load_debt
		@debt = current_user.debts.find(params[:debt_id])
	end
end
