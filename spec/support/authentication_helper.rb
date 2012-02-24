SPECIAL_URLS = [
]

ACTIONS = [
	[:roles, :index],
	[:roles, :show],
	[:roles, :new],
	[:roles, :create],
	[:roles, :edit],
	[:roles, :update],
	[:roles, :destroy],
	[:projects, :index],
	[:projects, :new],
	[:projects, :create],
	[:projects, :update],
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

GUEST_SHOULD_PASS = [
]

GUEST_SPECIAL_SHOULD_PASS = [
]

USER_SHOULD_PASS = GUEST_SHOULD_PASS + [
	[:projects, :index]
]

USER_SPECIAL_SHOULD_PASS = GUEST_SPECIAL_SHOULD_PASS + [
 "/"
]

PM_SHOULD_PASS = USER_SHOULD_PASS + [
	[:projects, :new],
	[:projects, :create]
]

PM_SPECIAL_SHOULD_PASS = USER_SPECIAL_SHOULD_PASS + [
]

ADMIN_SPECIAL_SHOULD_FAIL = [
]

ADMIN_SHOULD_FAIL = [
	[:roles, :edit],
	[:roles, :destroy],
	[:users, :edit],
	[:users, :new],
	[:users, :destroy],
	[:projects, :new],
	[:projects, :create],
	[:projects, :update]
]

def test_index(c)
	get url_for({:controller => c, :action => 'index'})
end

def success_index
	assert_response :success
end

def failure_index
	assert_response :missing
end

def test_show(c)
	obj = c.to_s.singularize.camelcase.constantize.make!
	get url_for(obj)
end

def success_show
	assert_response :success
end

def failure_show
	assert_response :missing
end

def test_new(c)
	get url_for({:controller => c, :action => 'new'})
end

def success_new
	assert_response :success
end

def failure_new
	assert_response :missing
end

def test_create(c)
	obj = c.to_s.singularize.camelcase.constantize.make
	post url_for(obj), obj.class.to_s.downcase.to_sym => obj.attributes
end

def success_create
	assert_response 302
end

def failure_create
	assert_response :missing
end

def test_edit(c)
	obj = c.to_s.singularize.camelcase.constantize.make!
	get url_for([:edit, obj])
end

def success_edit
	assert_response :success
end

def failure_edit
	assert_response :missing
end

def test_update(c)
	obj = c.to_s.singularize.camelcase.constantize.make!
	obj.updated_at = obj.updated_at + 3.hours
	put url_for(obj), obj.class.to_s.downcase.to_sym => obj.attributes
end

def success_update
	assert_response 302
end

def failure_update
	assert_response :missing
end

def test_destroy(c)
	obj = c.to_s.singularize.camelcase.constantize.make!
	delete url_for(obj)
end

def success_destroy
	assert_response 302
end

def failure_destroy
	assert_response :missing
end


