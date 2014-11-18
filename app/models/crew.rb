class Crew < ActiveRecord::Base
	
	belongs_to :creator, :class_name => "User", touch: true


	validates :name, presence: true
	validates :name, uniqueness: true if -> {self.name.present?}
	validates :name, format: { with: /[a-zA-Z]/ }
	validates :title, presence: true
	validates_length_of :name, :minimum => 3
	validates_length_of :name, :maximum => 42
	validates_length_of :title, :maximum => 140
	validates_length_of :description, :maximum => 512

	
	def to_param
		name
	end
end
