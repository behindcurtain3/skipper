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

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username,
  	:uniqueness => {
    	:case_sensitive => false
  	}

  validates_length_of :username, :minimum => 3
	validates_length_of :username, :maximum => 25

	has_many :creations, foreign_key: "creator_id", class_name: "Sub"
	has_many :posts
  has_many :active_subscriptions, class_name: "Subscription", foreign_key: "subscriber_id", dependent: :destroy
  has_many :subscriptions, through: :active_subscriptions, source: :sub

  attr_accessor :login

  # Subscribe to a sub
  def subscribe(sub)
    active_subscriptions.create(sub_id: sub.id)
  end

  # Unsubscribe from a sub
  def unsubscribe(sub)
    active_subscriptions.find_by(sub_id: sub.id).destroy
  end

  # Returns true if the current user is following the other user.
  def subscribed?(sub)
    subscriptions.include?(sub)
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  # return username instead of id
	def to_param
		username
	end

  protected

  	def email_required?
  		false
  	end
end
