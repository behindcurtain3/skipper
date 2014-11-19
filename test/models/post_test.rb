# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  token      :string           not null
#  title      :string           not null
#  url        :string
#  text       :string
#  user_id    :integer          not null
#  sub_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
  	@post = Post.new(title: "Example", url: "http://example.com", user_id: 1, sub_id: 1)
  end

  test "should be valid" do
  	assert @post.valid?
  end

  test "title should be present" do
  	@post.title = ""
  	assert_not @post.valid?
  end

  test "url or text should be present" do
  	@post.url = ""
  	@post.text = ""
  	assert_not @post.valid?

  	@post.url = "http://example.com"
  	assert @post.valid?

  	@post.url = ""
  	@post.text = "Example text"
  	assert @post.valid?
  end

  test "user_id should be present" do
  	@post.user_id = nil
  	assert_not @post.valid?
  end

  test "sub_id should be present" do
  	@post.sub_id = nil

  	assert_not @post.valid?
  end

  test "title length should be long enough" do
  	@post.title = "123"
  	assert_not @post.valid?
  end

  test "title length should not be too long" do
  	@post.title = "12345678901234567890123456789012345678901234567890
  								12345678901234567890123456789012345678901234567890
  								12345678901234567890123456789012345678901234567890"

  	assert_not @post.valid?
  end

  test "url should be the correct format" do
  	@post.url = "notaurl"
  	assert_not @post.valid?
  end
end
