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

class Post < ActiveRecord::Base
	resourcify
	before_create :randomize_token

	validates_presence_of :title
	validates_length_of :title, :minimum => 4
	validates_length_of :title, :maximum => 140
	validates_presence_of :user_id
	validates_presence_of :sub_id
	validate :has_url_or_text
	validates :url, format: { with: URI.regexp(%w(http https)) }, if: Proc.new { |a| a.url.present? }

	belongs_to :user
	belongs_to :sub

	def to_param
		token
	end

	def has_url_or_text
		unless [url?, text?].include?(true)
			errors.add :base, 'Must have a url or text'
		end
	end

	private

		def randomize_token
		  begin
		    self.token = SecureRandom.urlsafe_base64(6, false)
		  end while Post.where(:token => self.token).exists?
		end 

end
