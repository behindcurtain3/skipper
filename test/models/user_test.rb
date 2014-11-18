require 'test_helper'

class UserTest < ActiveSupport::TestCase

	test "username should not save without the correct length" do
		user = User.new
		user.username = "a"
		assert_not user.valid?, "Saved a user with a username that is too short"

		user.username = "abcdefghijklmnopqrstuvwxyz"
		assert_not user.valid?, "Saved a user with a username that is too long"
	end
end
