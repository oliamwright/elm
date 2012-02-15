require 'spec_helper'

describe Company do

	before(:each) do
	end

	it "should be valid" do
		company = Company.make!
		Company.count.should eq(1)
		company.should be_valid
	end

end

