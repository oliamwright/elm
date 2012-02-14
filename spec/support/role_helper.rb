require 'spec_helper'

def setup_roles
	Role.make!(:anyone)
	Role.make!(:admin)
end

