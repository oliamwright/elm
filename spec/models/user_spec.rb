require 'spec_helper'

describe User do

	before(:each) do
		setup_roles
		@admin = User.make!
		@user = User.make!
	end

	describe "Normal User" do
		it "should be valid" do
			@user.should be_valid
			User.count.should eq(2)
		end

		it "should not have admin role" do
			@user.has_global_role?(Role.Admin).should eq(false)
		end

	end

	describe "Admin User" do
		it "should have admin role" do
			@admin.has_global_role?(Role.Admin).should eq(true)
		end
	end

end

