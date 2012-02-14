require 'spec_helper'

describe "Authentication Requests" do
	before(:each) do
		setup_roles
		@admin = User.make!
		@user = User.make!
	end
end

