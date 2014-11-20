# == Schema Information
#
# Table name: subscriptions
#
#  id            :integer          not null, primary key
#  subscriber_id :integer
#  sub_id        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  def setup
    @subscription = Subscription.new(subscriber_id: 1, sub_id: 1)
  end

  test "should be valid" do
    assert @subscription.valid?
  end

  test "should require a subscriber_id" do
    @subscription.subscriber_id = nil
    assert_not @subscription.valid?
  end

  test "should require a sub_id" do
    @subscription.sub_id = nil
    assert_not @subscription.valid?
  end
end
