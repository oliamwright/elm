require 'spec_helper'

describe "Authentication Requests" do
	before(:each) do
		$-w = nil
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

		it "should NOT have access to sprints" do
			@sprint = Sprint.make!
			get project_sprints_url(@sprint.project)
			response.should redirect_to(new_user_session_url)
		end

		it "should NOT have access to backlog" do
			@project = Project.make!
			get "/projects/#{@project.id}/backlog"
			response.should redirect_to(new_user_session_url)
		end

		it "should NOT have access to dashboard" do
			get dashboard_url
			response.should redirect_to(new_user_session_url)
		end
	end

end

