# == Schema Information
#
# Table name: posts
#
#  id                      :integer          not null, primary key
#  token                   :string           not null
#  title                   :string           not null
#  url                     :string
#  text                    :string
#  user_id                 :integer          not null
#  sub_id                  :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  cached_votes_total      :integer          default("0")
#  cached_votes_score      :integer          default("0")
#  cached_votes_up         :integer          default("0")
#  cached_votes_down       :integer          default("0")
#  cached_weighted_score   :integer          default("0")
#  cached_weighted_total   :integer          default("0")
#  cached_weighted_average :float            default("0.0")
#

class Post < ActiveRecord::Base
	extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
	resourcify
	acts_as_votable
	before_create :randomize_token

	validates_presence_of :title
	validates_length_of :title, :minimum => 4
	validates_length_of :title, :maximum => 300
	validates :title, format: { with: /\A[A-Za-z0-9 .,!?$#%&()-+*~:"']+\z/i }
	validates_presence_of :user_id
	validates_presence_of :sub_id
	validate :has_url_or_text
	validates :url, format: { with: URI.regexp(%w(http https)) }, if: Proc.new { |a| a.url.present? }

	belongs_to :user
	belongs_to :sub
	has_many :comments

	# Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :title,
      [:title, :randomizer]
    ]
  end

	def has_url_or_text
		unless [url?, text?].include?(true)
			errors.add :base, 'Must have a url or text'
		end
	end

	private

		def randomize_token
			if self.token.nil?
			  begin
			    self.token = SecureRandom.urlsafe_base64(5, false)
			  end while Post.where(:token => self.token).exists?
			end
		end

		def randomizer
			randomize_token
			self.token
		end

end
