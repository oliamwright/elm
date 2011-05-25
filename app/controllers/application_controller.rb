class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :authenticate_user!, :except => [ :home ]
	before_filter :get_version

	def home
	end

	private

	def after_sign_in_path_for(resource)
		root_path
	end

	def get_version
		@VERSION = %x[cd #{Rails.root.to_s} && cat VERSION]
		if @VERSION.nil?
			@VERSION = "none"
		end
		@VERSION.chomp!
		if Rails.env == "development"
			@VERSION += " [dev]"
		end
		if Rails.env == "test"
			@VERSION += " [test]"
		end
	end

end
