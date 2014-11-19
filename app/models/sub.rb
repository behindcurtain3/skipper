# == Schema Information
#
# Table name: subs
#
#  id          :integer          not null, primary key
#  token       :string           not null
#  name        :string           default(""), not null
#  title       :string           default(""), not null
#  description :string
#  creator_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Sub < ActiveRecord::Base
	before_validation :create_token
	belongs_to :creator, :class_name => "User", touch: true

	validates :token, presence: true
	validates :token, uniqueness: true if -> {self.token.present?}
	validates :name, presence: true
	validates :name, uniqueness: true if -> {self.name.present?}
	validates :name, format: { with: /[a-zA-Z]/ }
	validates :title, presence: true
	validates_length_of :name, :minimum => 3
	validates_length_of :name, :maximum => 42
	validates_length_of :title, :maximum => 140
	validates_length_of :description, :maximum => 512

	has_many :posts
	has_many :active_subscriptions, class_name: "Subscription", foreign_key: "sub_id", dependent: :destroy
	has_many :subscribers, through: :active_subscriptions, source: :sub

	def to_param
		name
	end

	protected

		def create_token
			self.token = self.name.downcase
		end
end
