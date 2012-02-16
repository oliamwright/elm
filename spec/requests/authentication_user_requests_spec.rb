require 'spec_helper'

describe "Authentication Requests" do
	before(:each) do
		$-w = nil
		load_modules
		setup_user
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

		it "should be able to edit own project" do
			@project = Project.make!
			@user = @project.owner
			sign_in(@user)
			@project.updated_at = @project.updated_at + 3.hours
			put url_for(@project), :project => @project.attributes
			assert_response 302
		end

		it "should NOT be able to edit unowned project" do
			@project = Project.make!
			@user = User.make!
			sign_in(@user)
			@project.updated_at = @project.updated_at + 3.hours
			put url_for(@project), :project => @project.attributes
			assert_response :missing
		end

		it "should NOT have access to project sprints or backlog" do
			@sprint = Sprint.make!
			@project = @sprint.project
			sign_in(@user)
			get project_sprints_url(@project)
			assert_response :missing
			get "/projects/#{@project.id}/backlog"
			assert_response :missing
		end
	end

end

