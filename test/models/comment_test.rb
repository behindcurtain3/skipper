# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  token      :string           not null
#  user_id    :integer          not null
#  post_id    :integer          not null
#  parent_id  :integer
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class CommentTest < ActiveSupport::TestCase
	def setup
		@comment = Comment.new(content: "Example content", user_id: 1, post_id: 1)
	end

	test "should be valid" do
		assert @comment.valid?
	end

	test "content should be present" do
		@comment.content = ""
		assert_not @comment.valid?
	end

	test "user should be present" do
		@comment.user_id = nil
		assert_not @comment.valid?
	end

	test "post should be present" do
		@comment.post_id = nil
		assert_not @comment.valid?
	end
end
