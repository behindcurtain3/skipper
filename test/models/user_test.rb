# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  username               :string           default(""), not null
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		@user = User.new(username: "Example", password: "password")
		@user.save
	end

	test "should be valid" do
		assert @user.valid?
	end

	test "username should be present" do
		@user.username = ""
		assert_not @user.valid?
	end

	test "username should be long enough" do
		@user.username = "12"
		assert_not @user.valid?
	end

	test "username should not be too long" do
		@user.username = "12345678901234567890123456"
		assert_not @user.valid?
	end

	test "username should be unique" do
		dupuser = User.new(username: @user.username, password: "password")
		assert_not dupuser.valid?
	end

	test "email should be formatted correctly" do
		@user.email = "notanemail"
		assert_not @user.valid?
	end
end
