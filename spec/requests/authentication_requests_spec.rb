require 'spec_helper'

SPECIAL_URLS = [
	'/'
]

ACTIONS = [
	[:roles, :index],
	[:roles, :show],
	[:roles, :new],
	[:roles, :create],
	[:roles, :edit],
	[:roles, :update],
	[:roles, :destroy],
	[:companies, :index],
	[:companies, :show],
	[:companies, :new],
	[:companies, :create],
	[:companies, :update],
	[:users, :index],
	[:users, :show],
	[:users, :new],
	[:users, :edit],
	[:users, :update],
	[:users, :destroy]
]

ADMIN_SHOULD_FAIL = [
	[:roles, :edit],
	[:roles, :destroy],
	[:users, :edit],
	[:users, :new],
	[:users, :destroy]
]

ADMIN_SPECIAL_SHOULD_FAIL = [
]

USER_SHOULD_PASS = [
]

USER_SPECIAL_SHOULD_PASS = [
	"/"
]

GUEST_SHOULD_PASS = [
]

GUEST_SPECIAL_SHOULD_PASS = [
]

describe "Authentication Requests" do
	before(:each) do
		$-w = nil
		load_modules
		setup_roles
		assign_permissions
		@admin = User.make!
		@user = User.make!
	end

	describe "authenticated admin" do
	
		ACTIONS.each do |c,a|
			it "should #{ADMIN_SHOULD_FAIL.include?([c,a]) ? 'NOT ' : ''}have access to #{c}:#{a}" do
				sign_in(@admin)
				send("test_#{a}",c)
				if ADMIN_SHOULD_FAIL.include?([c,a])
					send("failure_#{a}")
				else
					send("success_#{a}")
				end
			end
		end
		SPECIAL_URLS.each do |url|
			it "should #{ADMIN_SPECIAL_SHOULD_FAIL.include?(url) ? 'NOT ' : ''}have access to #{url}" do
				sign_in(@admin)
				get url
				if ADMIN_SPECIAL_SHOULD_FAIL.include?(url)
					response.should redirect_to(new_user_session_url)
				else
					assert_response :success
				end
			end
		end
	end

	describe "authenticated user" do

		ACTIONS.each do |c,a|
			it "should #{USER_SHOULD_PASS.include?([c,a]) ? '' : 'NOT '}have access to #{c}:#{a}" do
				sign_in(@user)
				send("test_#{a}",c)
				if USER_SHOULD_PASS.include?([c,a])
					send("success_#{a}")
				else
					send("failure_#{a}")
				end
			end
		end
		SPECIAL_URLS.each do |url|
			it "should #{USER_SPECIAL_SHOULD_PASS.include?(url) ? '' : 'NOT '}have access to #{url}" do
				sign_in(@user)
				get url
				if USER_SPECIAL_SHOULD_PASS.include?(url)
					assert_response :success
				else
					assert_response :missing
				end
			end
		end
	end

	describe "unauthenticated guest" do
		ACTIONS.each do |c,a|
			it "should #{GUEST_SHOULD_PASS.include?([c,a]) ? '' : 'NOT '}have access to #{c}:#{a}" do
				send("test_#{a}",c)
				if GUEST_SHOULD_PASS.include?([c,a])
					send("success_#{a}")
				else
					response.should redirect_to(new_user_session_url)
				end
			end
		end
		SPECIAL_URLS.each do |url|
			it "should #{GUEST_SPECIAL_SHOULD_PASS.include?(url) ? '' : 'NOT '}have access to #{url}" do
				get url
				if GUEST_SPECIAL_SHOULD_PASS.include?(url)
					assert_response :success
				else
					response.should redirect_to(new_user_session_url)
				end
			end
		end
	end

end

