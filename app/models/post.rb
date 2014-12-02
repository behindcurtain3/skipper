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
#  slug                    :string
#

class Post < ActiveRecord::Base
	extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
	resourcify
	acts_as_votable
	before_create :randomize_token

	validates :title, 
		presence: true, 
		length: { minimum: 4, maximum: 300 },
		format: { with: /\A[\w\W]+\z/i }
	validates :user_id, presence: true
	validates :sub_id, presence: true
	validate :has_url_or_text
	validates :url, format: { with: URI.regexp(%w(http https)) }, if: Proc.new { |a| a.url.present? }

	belongs_to :user
	belongs_to :sub
	has_many :comments

	scope :popular, -> { order("cached_weighted_score desc") }
	scope :newest, -> { order("created_at desc") }
	scope :liked, -> { order("cached_votes_up desc") }
	scope :last_week, lambda { where("created_at >= :date", :date => 1.week.ago) }
	scope :last_month, lambda { where("created_at >= :date", :date => 1.month.ago) }

	def get_posts(tag, order, filter)

		posts = Post.all

		unless tag.blank?
			posts = posts.tagged_with(tag)
		end

		# apply scopes for ordering
		posts = posts.popular if order == "popular"
		posts = posts.newest if order == "newest"
		posts = posts.liked if order == "liked"

		# apply scopes for filtering
		posts = posts.last_week if filter == "week"
		posts = posts.last_month if filter == "month"

		# only return active posts
		posts = posts.running

		return posts
	end

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
