class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :authenticate_user!, :except => [ :home ]

	def home
	end
end
