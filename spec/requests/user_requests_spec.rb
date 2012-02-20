require 'spec_helper'

describe "User Requests" do
	before(:each) do
		@admin = User.make!
		@user = User.make!
	end

	it "failed sign in should not create a current_user" do
		fail_sign_in(@user)
		assert_response :success
		assert controller.current_user.should be_nil
	end

	it "proper sign in should create a current_user" do
		sign_in(@user)
		assert_response :success
		assert controller.current_user.should eq(@user)
	end
end

