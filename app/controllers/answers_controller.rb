class AnswersController < ApplicationController

	def create
		@a = Answer.new(params[:answer])
		@a.user = current_user
		@a.save
		redirect_to_last_page
	end

end
