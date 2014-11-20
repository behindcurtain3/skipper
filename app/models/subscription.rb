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

class Subscription < ActiveRecord::Base
	belongs_to :subscriber, class_name: "User"
	belongs_to :sub, class_name: "Sub"

	validates :subscriber_id, presence: true
	validates :sub_id, presence: true
end
