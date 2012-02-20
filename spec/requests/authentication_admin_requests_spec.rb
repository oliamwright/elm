require 'spec_helper'

describe "Authentication Requests" do
	before(:each) do
		$-w = nil
		setup_admin
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

		it "should be able to become another user" do
			@user = User.make!
			sign_in(@admin)
			controller.current_user.should eq(@admin)
			post_via_redirect become_user_url(@user)
			assert_response :success
			controller.current_user.should eq(@user)
		end
	end

end

