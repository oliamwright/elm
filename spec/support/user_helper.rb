
def sign_in(user)
	do_sign_in(user, 'password')
end

def fail_sign_in(user)
	do_sign_in(user, 'notpassword')
end

def do_sign_in(user, password)
	post_via_redirect user_session_path, 'user[email]' => user.email, 'user[password]' => password
end
