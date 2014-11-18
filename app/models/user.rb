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

	has_many :creations, foreign_key: "creator_id", class_name: "Crew"

  attr_accessor :login

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
