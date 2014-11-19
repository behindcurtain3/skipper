class Subscription < ActiveRecord::Base
	belongs_to :subscriber, class_name: "User"
	belongs_to :sub, class_name: "Sub"

	validates :subscriber_id, presence: true
	validates :sub_id, presence: true
end
