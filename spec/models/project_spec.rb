require 'spec_helper'

describe Project do

	before(:each) do
	end

	it "should be valid" do
		project = Project.make!
		Project.count.should eq(1)
		project.should be_valid
		project.owner.should eq(User.first)
	end

end

