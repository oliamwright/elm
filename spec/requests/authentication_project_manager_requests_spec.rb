require 'spec_helper'

describe "Authentication Requests" do
	before(:each) do
		$-w = nil
		load_modules
	end

	describe "authenticated project manager" do
		before(:each) do
			setup_project_manager
		end

		ACTIONS.each do |c,a|
			it "should #{PM_SHOULD_PASS.include?([c,a]) ? '' : 'NOT '}have access to #{c}:#{a}" do
				sign_in(@project_manager)
				send("test_#{a}",c)
				if PM_SHOULD_PASS.include?([c,a])
					send("success_#{a}")
				else
					send("failure_#{a}")
				end
			end
		end
		SPECIAL_URLS.each do |url|
			it "should #{PM_SPECIAL_SHOULD_PASS.include?(url) ? '' : 'NOT '}have access to #{url}" do
				sign_in(@project_manager)
				get url
				if PM_SPECIAL_SHOULD_PASS.include?(url)
					assert_response :success
				else
					assert_response :missing
				end
			end
		end

		it "should own a project and have Project Owner role" do
			sign_in(@project_manager)
			project = Project.make
			post url_for(project), :project => project.attributes
			assert_response 302
			Project.count.should eq(1)
			Project.first.owner.should eq(@project_manager)
			@project_manager.has_project_role?(Project.first, Role.ProjectOwner).should eq(true)
		end

	end
end
