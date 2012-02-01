class QuestionsController < ApplicationController

	def create
		@q = Question.new(params[:question])
		@q.user = current_user
		@q.save
		redirect_to_last_page
	end

end
