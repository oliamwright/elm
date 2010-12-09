class Account < ActiveRecord::Base
  belongs_to :user

	scope :for_user, lambda { |user|
		where("accounts.user_id = ?", user.id)
	}

end
